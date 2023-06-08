color="\e[32m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

stat_check() {
  if [ $1 -eq 0 ];then
    echo SUCCESS
  else
    echo FAILURE
  fi
}

app_presetup() {
  echo -e "${color} adding user ${nocolor}"
  id roboshop &>>$log_file
  if [ $? -eq 1 ];then
  useradd roboshop &>>${log_file}
  fi
  stat_check $?

  echo -e "$color application directory ${nocolor}"
  rm -rf ${app_path} &>>${log_file}
  mkdir ${app_path}

  stat_check $?

  echo -e "$color downloading application code $nocolor"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  cd ${app_path}

  stat_check $?
  echo -e "$color unzip application code $nocolor"
  unzip /tmp/${component}.zip &>>${log_file}
  cd ${app_path}

  stat_check $?
}

systemd_setup() {
    echo -e "$color setup systemD service $nocolor"
    cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service  &>>${log_file}
    if [ $? -eq 0 ];then
        echo SUCCESS
      else
        echo FAILURE
    fi
    echo -e "${color} system ${component} service ${nocolor}"
    systemctl daemon-reload  &>>${log_file}
    systemctl enable ${component}  &>>${log_file}
    systemctl restart ${component}  &>>${log_file}
    if [ $? -eq 0 ];then
      echo SUCCESS
    else
      echo FAILURE
    fi
}

nodejs() {
echo -e "$color configuring node js $nocolor"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

echo -e "$color installing nodejs$nocolor"
yum install nodejs -y &>>${log_file}

app_presetup

echo -e "$color installing dependencies $nocolor"
npm install &>>${log_file}



systemd_setup
}

mongo_schema_setup() {
  echo -e "${color} copying mongodb repo file here ${nocolor}"
  cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

  echo -e "${color} installing mongodb ${nocolor}"
  yum install mongodb-org-shell -y &>>${log_file}

  echo -e "${color} loading schema ${nocolor}"
  mongo --host mongodb-dev.trrdops.store <${app_path}/schema/$component.js &>>${log_file}
}
mysql_schema_setup() {
    echo -e "${color} loading mysql here ${nocolor}"
    yum install mysql -y  &>>${log_file}

    echo -e "${color} loading schema ${nocolor}"
    mysql -h mysql-dev.trrdops.store -uroot -pRoboShop@1 < ${app_path}/schema/${component}.sql   &>>${log_file}

}

maven() {
  echo -e "${color} installing MAVEN package ${nocolor}"
  yum install maven -y &>>${log_file}

  app_presetup

  echo -e "${color} download the dependencies ${nocolor}"
  mvn clean package  &>>${log_file}
  mv target/${component}-1.0.jar shipping.jar  &>>${log_file}

  echo -e "${color} copying repo file ${nocolor}"
  cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>>${log_file}

  mysql_schema_setup
  systemd_setup

}

python() {
  echo -e "${color} installing python ${nocolor}"
  yum install python36 gcc python3-devel -y &>>${log_file}

  stat_check $?
  app_presetup

  echo -e "${color} downloading the dependencies here ${nocolor}"
  pip3.6 install -r requirements.txt  &>>${log_file}
  stat_check $?

  sed -i -e "s/roboshop_app_password/$1" /home/centos/roboshop-shell/$component.service
  systemd_setup



}