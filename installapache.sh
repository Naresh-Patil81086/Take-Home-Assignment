#! /bin/bash
apt-get install -y apache2
systemctl start apache2
echo "<h1>Take Home Assignment</h1>"| sudo tee /var/www/html/index.html
sudo mkfs.ext4 /dev/xvdf
sudo mount /dev/xvdf /var/log
sudo useradd naresh -m
sudo chpasswd << 'END'
${username}:${password}
END
sudo sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
sudo systemctl restart sshd
