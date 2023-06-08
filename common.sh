color="\e[32m"
nocolor="${nocolor}"
log_file="/tmp/roboshop.log"
app_path="${app_path}"

app_presetup() {
  echo -e "$color adding user $nocolor"
  useradd roboshop &>>${log_file}

  echo -e "$color application directory$nocolor"
  rm -rf ${app_path} &>>${log_file}
  mkdir ${app_path}

  echo -e "$color downloading application code $nocolor"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  cd ${app_path}

  echo -e "$color unzip application code $nocolor"
  unzip /tmp/${component}.zip &>>${log_file}
  cd ${app_path}
}

systemd_setup() {
    echo -e "$color setup systemD service $nocolor"
    cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service  &>>${log_file}

    echo -e "${color} system restart ${nocolor}"
    systemctl daemon-reload  &>>${log_file}
    systemctl enable shipping  &>>${log_file}
    systemctl restart shipping  &>>${log_file}
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
mysql_schema_setp() {
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



  systemd_setup

}

python() {
  echo -e "${color} installing python ${nocolor}"
  yum install python36 gcc python3-devel -y &>>${log_file}

  app_presetup

  echo -e "${color} downloading the dependencies here ${nocolor}"
  pip3.6 install -r requirements.txt  &>>${log_file}

  systemd_setup



}