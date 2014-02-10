#
# Cookbook Name:: memcached
# Recipe:: default
#
#install package
package "memcached" do
  action :install
end

# removing default init script and sysconfig settings
case node[:platform_family:]
when 'centos', 'redhat', 'amazon', 'scientific'
  file "#{node[:memcached][:init_dir]}/memcached" do
    action :delete
  end

  ##Disable services on centos family Services
  service "memcached" do
    supports :status => true, :restart => true, :start => true, :stop => true
    action [ :disable ]
  end
end

file "#{node[:memcached][:options_dir]}/memcached" do
  action :delete
end

##add ohai plugin
cookbook_file "/etc/chef/ohai_plugins/memcached-info.rb" do 
  source "plugins/memcached-info.rb"
  owner "root"
  group "root"
end
