echo -e "\e[31m configure erlang \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>/tmp/roboshop.log

echo -e "\e[31m  configure yum repos \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.log

echo -e "\e[31m installing rabbit mq \e[0m"
yum install rabbitmq-server -y &>>/tmp/roboshop.log

echo -e "\e[31m starting server here \e[0m"
systemctl enable rabbitmq-server  &>>/tmp/roboshop.log
systemctl restart rabbitmq-server  &>>/tmp/roboshop.log

echo -e "\e[31m adding user and password \e[0m"
rabbitmqctl add_user roboshop $1  &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>/tmp/roboshop.log
