#
# Cookbook Name:: b2app
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


remote_file '/tmp/b2artifact.tgz' do
  source 'https://s3-us-west-2.amazonaws.com/prakash26790/b2artifact.tgz'
  owner 'ec2-user'
  group 'ec2-user'
 # mode '0755'
  action :create
end

execute "extract files" do
  command "mkdir -p /tmp/web-app; tar -zxvf /tmp/b2artifact.tgz -C /tmp/web-app"
  user 'ec2-user'
end

execute "move files" do
  command " cp -r /tmp/web-app /home/ec2-user/"
  user 'ec2-user'
end

remote_file "Copy beehively file" do 
  path "/etc/cron.d/beehively" 
  source "file:///home/ec2-user/web-app/scripts/beehively"
  owner 'ec2-user'
  group 'ec2-user'
 # mode 0755
end

remote_file "Copy metrics file" do 
  path "/home/ec2-user/bin/metrics.sh" 
  source "file:///home/ec2-user/web-app/scripts/metrics.sh"
  owner 'ec2-user'
  group 'ec2-user'
 # mode 0755
end

remote_file "Copy clock file" do 
  path "/etc/sysconfig/clock" 
  source "file:///home/ec2-user/web-app/scripts/clock"
  #owner 'ec2-user'
  #group 'ec2-user'
  #mode 0755
end

execute "BeforeInstall" do
  command "sh /home/ec2-user/web-app/scripts/before.sh"
  user 'ec2-user'
end

execute "AfterInstall" do
  command "sh /home/ec2-user/web-app/scripts/after.sh"
  user 'ec2-user'
end

execute "ApplicationStart" do
  command "sh /home/ec2-user/web-app/scripts/start.sh"
  user 'ec2-user'
end

execute "ValidateService" do
  command "sh /home/ec2-user/web-app/scripts/validate.sh"
  user 'ec2-user'
end
