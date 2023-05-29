echo -e "\e[31m configuring node js \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m installing nodejs\e[0m"
yum install nodejs -y

echo -e "\e[33m adding user \e[0m"
useradd roboshop

echo -e "\e[34m application directory\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[35m downloading application code \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[31m unzip application code \e[0m"
unzip /tmp/catalogue.zip
cd /app

echo -e "\e[33m installing dependencies \e[0m"
npm install

echo -e "\e[34m setup systemD service \e[0m"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[31m starting catalogue server \e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[32m copying mongodb repo file \e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33m installing mongodb \e[0m"
yum install mongodb-org-shell -y

echo -e "\e[34m loading schema \e[0m"
mongo --host mongodb-dev.trrdops.store </app/schema/catalogue.js
