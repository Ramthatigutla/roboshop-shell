echo -e "\e[31m installing golang \e[0m"
yum install golang -y  &>>/tmp/roboshop.log

echo -e "\e[31m adding application user \e[0m"
useradd roboshop  &>>/tmp/roboshop.log

echo -e "\e[31m creating directory app \e[0m"
rm -rf /app  &>>/tmp/roboshop.log
mkdir /app  &>>/tmp/roboshop.log

echo -e "\e[31m downloading application content \e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip  &>>/tmp/roboshop.log
cd /app

echo -e "\e[31m unzipping dispatch content \e[0m"
unzip /tmp/dispatch.zip  &>>/tmp/roboshop.log
cd /app

echo -e "\e[31m downloading dependencies here \e[0m"
go mod init dispatch  &>>/tmp/roboshop.log
go get  &>>/tmp/roboshop.log
go build  &>>/tmp/roboshop.log

echo -e "\e[31m copying dispatching service \e[0m"
cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service  &>>/tmp/roboshop.log

echo -e "\e[31m starting dispatch server \e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable dispatch  &>>/tmp/roboshop.log
systemctl restart dispatch  &>>/tmp/roboshop.log