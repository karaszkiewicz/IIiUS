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
sudo useradd -p $(perl -e'print crypt("12345", "aa")') -d /home/$login -m -s /bin/bash $login -g new-user

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

sudo chmod a-w /home/$login/public_html
sudo chown -R $login:new-user  /home/$login/public_html
sudo chmod -R 0775 /home/$login/public_html
sudo chmod 775 /home/$login

sudo chmod a-w /home/$login/public_html/private_html
sudo chown -R $login:new-user  /home/$login/public_html/private_html
sudo chmod -R 0775 /home/$login/public_html/private_html

sudo smbpasswd -a $login
sudo usermod -a -G mail $login

#sudo mkdir -p /var/www/html/$login
#sudo usermod -m -d /var/www/html/$login $login
#sudo chown -R $login:new-user /var/www/html/$login

clear
echo "COMPLETED"
echo "Password: 12345"
echo ""
echo $login

