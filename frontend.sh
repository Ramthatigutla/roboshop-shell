echo -e "\e[31m installing nginx\e[0m"
yum install nginx -y &>>/tmp/roboshop.log

echo -e "\e[32m removing existing nginx webframe \e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log

echo -e "\e[33m downlaoding new nginx content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[34m creating a directory to unzip the downloaded content \e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[35m updating frontend configuration for roboshop \e[0m"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/roboshop.log

echo -e "\e[36m enabling nginx \e[0m"
systemctl enable nginx &>>/tmp/roboshop.log

echo -e "\e[33m restarting nginx server \e[0m"
systemctl restart nginx &>>/tmp/roboshop.log