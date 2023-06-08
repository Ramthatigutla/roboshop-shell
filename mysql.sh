source common.sh

echo -e "${color}disable mysql default version ${nocolor}"
yum module disable mysql -y &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}copying mysql repo file ${nocolor}"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}install mysql community server ${nocolor}"
yum install mysql-community-server -y &>>/tmp/roboshop.log
stat_check $?


echo -e "${color}enable and restart ${nocolor}"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl restart mysqld &>>/tmp/roboshop.log
stat_check $?


echo -e "${color}setup mysql password ${nocolor}"
mysql_secure_installation --set-root-pass $1 &>>/tmp/roboshop.log
stat_check $?


