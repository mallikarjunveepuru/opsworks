#
# Cookbook Name:: java_app
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#dbip1 = data_bag_item('db_ip','db_instance_ip')
#$db = dbip1['ip']

execute "update_apt_repo" do
	command "apt-get update"
end

package 'git' do
	action :install
end

package 'maven' do
	action :install
end

execute "pull_app_repo" do
	command "cd /home/ubuntu ; git clone https://github.com/mallikarjunveepuru/spring.git"
	action :run
end

#template "/home/ubuntu/spring/src/main/resources/environment/db.properties" do

#  source "db.properties.erb"

#  variables( :ip => dbip1['ip'])

#end

#execute "change_the_ip_of_db" do
#	command "echo #$db > /tmp/ip.txt ; sed -i -e \"s/localhost/#$db/g\" /home/ubuntu/spring/src/main/resources/environment/db.properties"
#	command "/bin/bash /tmp/db.sh"
#	action :run
end

execute "compile maven project" do
	command "cd /home/ubuntu/spring/ ; mvn clean install -U"
	action :run
end

package 'tomcat7' do
	action :install
end

execute "move artifacts to tomcat" do
	command "export JAVA_HOME=\/usr\/lib\/jvm\/java-8-oracle ; export CATALINA_HOME=\/usr\/share\/tomcat7 ; sed -i -e \"s/java-7-oracle/java-7-oracle **\/usr\/lib\/jvm\/java-8-oracle**/g\" /etc/init.d/tomcat7 ; sudo mv /home/ubuntu/spring/target/spring-example.war /var/lib/tomcat7/webapps/ ; /etc/init.d/tomcat7 restart"
	action :run
end
