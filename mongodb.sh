echo -e "\e[31m copying mongodb repo file \e[0m"
cp mongodb.repo /etc/yum.repos.d/mongodb.repo

echo -e "\e[31m installing mongodb \e[0m"
yum install mongodb-org -y

#modify the config file for listner address

echo -e "\e[31m enabling mongodb \e[0m"
systemctl enable mongod

echo -e "\e[31m irestarting mongodb \e[0m"
systemctl restart mongod