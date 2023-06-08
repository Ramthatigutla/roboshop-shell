echo -e "\e[31m installing MAVEN package \e[0m"
yum install maven -y &>>/tmp/roboshop.log

echo -e "\e[31m Adding application user \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[31m Adding directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app  &>>/tmp/roboshop.log

echo -e "\e[31m downloading application code \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip  &>>/tmp/roboshop.log
cd /app

echo -e "\e[31m unzipping code \e[0m"
unzip /tmp/shipping.zip  &>>/tmp/roboshop.log
cd /app

echo -e "\e[31m download the dependencies \e[0m"
mvn clean package  &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar  &>>/tmp/roboshop.log

echo -e "\e[31m copying repo file \e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>/tmp/roboshop.log

echo -e "\e[31m loading mysql here \e[0m"
yum install mysql -y  &>>/tmp/roboshop.log

echo -e "\e[31m loading schema \e[0m"
mysql -h mysql-dev.trrdops.store -uroot -pRoboShop@1 < /app/schema/shipping.sql   &>>/tmp/roboshop.log

echo -e "\e[31m system restart \e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable shipping  &>>/tmp/roboshop.log
systemctl restart shipping  &>>/tmp/roboshop.log






