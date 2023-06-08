source common.sh

echo -e "${color} installing redis repo ${nocolor}"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} enabling redis 6 version here ${nocolor}"
yum module enable redis:remi-6.2 -y  &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} installing redis${nocolor}"
yum install redis -y  &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} updating listner address ${nocolor}"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf  /etc/redis/redis.conf  &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} restarting redis now ${nocolor}"
systemctl enable redis  &>>/tmp/roboshop.log
systemctl restart redis  &>>/tmp/roboshop.log
stat_check $?