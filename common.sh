color="\e[32m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

nodejs() {
echo -e "$color configuring node js $nocolor"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

echo -e "$color installing nodejs$nocolor"
yum install nodejs -y &>>${log_file}

echo -e "$color adding user $nocolor"
useradd roboshop &>>${log_file}

echo -e "$color application directory$nocolor"
rm -rf ${app_path} &>>${log_file}
mkdir ${app_path}

echo -e "$color downloading application code $nocolor"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_file}
cd ${app_path}

echo -e "$color unzip application code $nocolor"
unzip /tmp/$component.zip &>>${log_file}
cd ${app_path}

echo -e "$color installing dependencies $nocolor"
npm install &>>${log_file}

echo -e "$color setup systemD service $nocolor"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service  &>>${log_file}

echo -e "$color starting $component server $nocolor"
systemctl daemon-reload  &>>${log_file}
systemctl enable $component &>>${log_file}
systemctl restart $component &>>${log_file}
}

