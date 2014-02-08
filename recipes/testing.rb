# insure server stuff is installed
include_recipe "memcached::default"
#
# # instance name
instance_name = "test"
#
memcached_instance instance_name do
  action :create
  ##could either use node[:ipaddress] or one from the ohai attribute
  bind_ip node[:memcached][:test]
  port 11211
  max_connections 4096
  cachesize 4096
end
