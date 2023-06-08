echo -e "\e[31m disable mysql default version \e[0m"
yum module disable mysql -y &>>/tmp/roboshop.log

echo -e "\e[31m copying mysql repo file \e[0m"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log

echo -e "\e[31m install mysql community server \e[0m"
yum install mysql-community-server -y &>>/tmp/roboshop.log


echo -e "\e[31m enable and restart \e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl restart mysqld &>>/tmp/roboshop.log


echo -e "\e[31m setup mysql password \e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log


