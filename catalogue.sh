echo -e "\e[31m configuring node js \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log
echo -e "\e[32m installing nodejs\e[0m"
yum install nodejs -y &>>/tmp/roboshop.log
echo -e "\e[33m adding user \e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[34m application directory\e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app
echo -e "\e[35m downloading application code \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log
echo -e "\e[36m switch to app directory \e[0m"
cd /app
echo -e "\e[31m unzip application code \e[0m"
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
echo -e "\e[32m switch to app directory \e[0m"
cd /app
echo -e "\e[33m installing dependencies \e[0m"
npm install &>>/tmp/roboshop.log
echo -e "\e[34m setup systemD service \e[0m"
cp /home/centos/reboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log
echo -e "\e[31m starting catalogue server \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl retart catalogue &>>/tmp/roboshop.log
echo -e "\e[32m copying mongodb repo file \e[0m"
cp /home/centos/reboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
echo -e "\e[33m installing mongodb \e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log
echo -e "\e[34m loading schema \e[0m"
mongosh --host mongodb-dev.trrdops.store </app/schema/catalogue.js
