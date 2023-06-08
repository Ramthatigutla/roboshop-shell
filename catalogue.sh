component=catalogue
color="\e[31m"
nocolor="\e[0m"


echo -e "$color configuring node js $nocolor"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "$color installing nodejs$nocolor"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "$color adding user $nocolor"
useradd roboshop &>>/tmp/roboshop.log

echo -e "$color application directory$nocolor"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "$color downloading application code $nocolor"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>/tmp/roboshop.log
cd /app

echo -e "$color unzip application code $nocolor"
unzip /tmp/$component.zip &>>/tmp/roboshop.log
cd /app

echo -e "$color installing dependencies $nocolor"
npm install &>>/tmp/roboshop.log

echo -e "$color setup systemD service $nocolor"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service  &>>/tmp/roboshop.log

echo -e "$color starting $component server $nocolor"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable $component &>>/tmp/roboshop.log
systemctl restart $component &>>/tmp/roboshop.log

echo -e "$color copying mongodb repo file $nocolor"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "$color installing mongodb $nocolor"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "$color loading schema now $nocolor"
mongo --host mongodb-dev.trrdops.store </app/schema/$component.js  &>>/tmp/roboshop.log

