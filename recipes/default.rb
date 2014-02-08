#
# Cookbook Name:: memcached
# Recipe:: default
#
#install package
package "memcached" do
    action :install
end

# removing default init script and sysconfig settings
file "#{node[:memcached][:init_dir]}/memcached" do
	action :delete
end

file "#{node[:memcached][:config_dir]}/memcached" do
	action :delete
end

##add ohai plugin
cookbook_file "/etc/chef/ohai_plugins/memcache-info.rb" do 
    source "plugins/memcache-info.rb"
    owner "root"
    group "root"
end

#Services
service "memcached" do
    supports :status => true, :restart => true, :start => true, :stop => true
    action [ :disable ]
end
