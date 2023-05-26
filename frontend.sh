echo -e "\e[31m installing nginx\e[0m"
yum install nginx -y
echo -e "\e[32m removing existing nginx webframe \e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[33m downlaoding new nginx content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e "\e[34m creating a directory to unzip downloaded content \e[0m"
cd /usr/share/nginx/html
echo -e "\e[35m unzipping new downloaded nginx content \e[0m"
unzip /tmp/frontend.zip
#we need to copy config file
echo -e "\e[36m enabling nginx \e[0m"
systemctl enable nginx
echo -e "\e[33m restarting nginx server \e[0m"
systemctl restart nginx