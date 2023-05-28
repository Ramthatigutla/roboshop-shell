echo -e "\e[31m copying mongodb repo file \e[0m"
cp mongodb.repo /etc/yum.repos.d/mongodb.repo >>/tmp/roboshop.log
echo -e "\e[31m installing mongodb \e[0m"
yum install mongodb-org -y >>/tmp/roboshop.log
#modify the config file for listner address
echo -e "\e[31m enabling mongodb \e[0m"
systemctl enable mongod >>/tmp/roboshop.log
echo -e "\e[31m restarting mongodb \e[0m"
systemctl restart mongod >>/tmp/roboshop.log