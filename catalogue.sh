source common.sh
component=catalogue

nodejs

echo -e "$color copying mongodb repo file $nocolor"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

echo -e "$color installing mongodb $nocolor"
yum install mongodb-org-shell -y &>>${log_file}

echo -e "$color loading schema now $nocolor"
mongo --host mongodb-dev.trrdops.store <${app_path}/schema/$component.js  &>>${log_file}

