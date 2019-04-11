#!/bin/bash
echo Podaj imie i nazwisko
read imie nazwisko
login=${imie::1}
login=${login,,}
login=$login${nazwisko,,}
login=$(echo $login | sed 'y/ęóąśćłżź/eoasclzz/')
i=1
temp=$login
while : ; do
	if getent passwd $login > /dev/null 2>&1; then	
		login=$temp$i
		let "i=i+1"
	else
		break
	fi
done
echo $login
password=$login

sudo mkdir -p /etc/skel/public_html
sudo mkdir -p /etc/skel/public_html/private_html
#create user
sudo useradd -p $(perl -e'print crypt("12345", "aa")') -d /home/$login -m -s /bin/bash $login
sudo chage -d 0 $login

echo "alias hs='history | grep'" | sudo tee -a /home/$login/.bashrc
echo "alias ll='ls -l'" | sudo tee -a /home/$login/.bashrc
echo "export PS1='[\[\e[0;32m\]\u\[\e[m\][\[\e[0;35m\]\w\[\e[m\]] $ '" | sudo tee -a /home/$login/.bashrc

private=/home/$login/public_html/private_html
sudo touch $private/.htaccess
echo "AuthType Basic" | sudo tee -a $private/.htaccess
echo "AuthName \"Password Protected Area\"" | sudo tee -a $private/.htaccess
echo "AuthUserFile /home/$login/.htpasswd" | sudo tee -a $private/.htaccess
echo "Require valid-user" | sudo tee -a $private/.htaccess
sudo htpasswd -cb /home/$login/.htpasswd $login $login

clear
echo "COMPLETED"
echo "Aliases:"
echo "hs  history"
echo "ll  ls -l"
echo ""
echo $login

