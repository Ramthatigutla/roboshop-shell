echo -e "\e[31m installing python \e[0m"
yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log

echo -e "\e[31m adding user \e[0m"
useradd roboshop  &>>/tmp/roboshop.log

echo -e "\e[31m creating app directory \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m downloading the application code \e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[31m unzipping the content \e[0m"
unzip /tmp/payment.zip  &>>/tmp/roboshop.log
cd /app

echo -e "\e[31m downloading the dependencies \e[0m"
pip3.6 install -r requirements.txt  &>>/tmp/roboshop.log

echo -e "\e[31m copying payment services \e[0m"
cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service  &>>/tmp/roboshop.log

echo -e "\e[31m starting the payment server \e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable payment  &>>/tmp/roboshop.log
systemctl restart payment  &>>/tmp/roboshop.log

