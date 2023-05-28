echo -e "\e[31m copying mongodb repo file \e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log

echo -e "\e[31m installing mongodb \e[0m"
yum install mongodb-org -y &>>/tmp/roboshop.log

echo -e "\e[31m updating mongodb listner address using sed editor \e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongodb.conf

echo -e "\e[31m restarting mongodb \e[0m"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl restart mongod &>>/tmp/roboshop.log