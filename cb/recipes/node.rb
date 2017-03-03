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

execute "install node js" do
	command "curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash - ; sudo apt-get install nodejs"
	action :run
end

execute "clone repo" do
  command "cd ~ ; git clone https://github.com/mallikarjunveepuru/node-vs-java-tests.git ; cd node-vs-java-tests ; npm install ; nodejs app.js"
  action :run
end
