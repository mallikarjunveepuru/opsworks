#
# Cookbook Name:: java_app
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
dbip1 = data_bag_item('app_ip','app_instance_ip')
$db = dbip1['ip']

execute "update_apt_repo" do
	command "apt-get update"
end

execute "set selections" do
        command "echo \"mysql-server mysql-server/root_password password root\" | debconf-set-selections ; echo \"mysql-server mysql-server/root_password_again password root\" | debconf-set-selections"
	
end

execute "mysql installation" do
        command "sudo apt-get install mysql-server -y ; service mysql restart"
        action :run
end

execute "change the binding address and start" do
	command "sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf ; sudo service mysql restart ; sleep 30 ; sudo apt-get install mysql-client-core-5.5 -y ; apt-get install mariadb-client-core-5.5 -y ; service mysql restart"
	action :run
end

execute "create a user for db" do
#	command "mysql -u root -proot -e \"CREATE USER 'root'@'#$db' IDENTIFIED BY 'root';\""
	command "mysql -u root -proot -e \"CREATE USER 'root'@'%' IDENTIFIED BY 'root';\""
	action :run
end

execute "create database in mysql" do

  command "mysql -u root -proot -e \"CREATE DATABASE Inventory;\""

  action :run

end

execute "create table" do
	command "mysql -u root -proot -e \"USE Inventory; CREATE TABLE Product (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,description TEXT,price DOUBLE); INSERT INTO Product values(12,'gopaddle',9000000);\""
	action :run
end

execute "grant privileges for user" do
#	command "mysql -u root -proot -e \"GRANT ALL PRIVILEGES ON Inventory.* TO 'root'@'#$db';\""
	command "mysql -u root -proot -e \"GRANT ALL PRIVILEGES ON Inventory.* TO 'root'@'%';\""
	action :run
end

execute "flush privileges" do
	command "mysql -u root -proot -e \"FLUSH PRIVILEGES;\""
	action :run
end

