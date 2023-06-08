source common.sh

echo -e "${color}installing nginx ${nocolor}"
yum install nginx -y &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}removing existing nginx webframe ${nocolor}"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}downlaoding new nginx content ${nocolor}"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}creating a directory to unzip the downloaded content ${nocolor}"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}updating frontend configuration for roboshop ${nocolor}"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}enabling nginx ${nocolor}"
systemctl enable nginx &>>/tmp/roboshop.log

echo -e "${color}restarting nginx server ${nocolor}"
systemctl restart nginx &>>/tmp/roboshop.log
stat_check $?