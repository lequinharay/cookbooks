#
# Cookbook Name:: php55
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# epel repository導入
remote_file "/tmp/#{node['epel']['file_name']}" do
  source "#{node['epel']['remote_uri']}"
  not_if { ::File.exists?("/tmp/#{node['epel']['file_name']}") }
end

package node['epel']['file_name'] do
  action :install
  provider Chef::Provider::Package::Rpm
  source "/tmp/#{node['epel']['file_name']}"
end

# remi repository導入
remote_file "/tmp/#{node['remi']['file_name']}" do
  source "#{node['remi']['remote_uri']}"
  not_if { ::File.exists?("/tmp/#{node['remi']['file_name']}") }
end

package node['remi']['file_name'] do
  action :install
  provider Chef::Provider::Package::Rpm
  source "/tmp/#{node['remi']['file_name']}"
end


# phpインストール
%w{php php-devel php-mbstring php-mcrypt php-mysql php-phpunit-PHPUnit php-pecl-xdebug mod_ssl}.each do |p|
	package p do
		action :install
		options "--enablerepo=epel,remi --enablerepo=remi-php55"
	end
end

# php設定
template "php.ini" do
	path "/etc/php.ini"
	source "php.ini.erb"
	mode 0644
	notifies :restart, 'service[httpd]'
end