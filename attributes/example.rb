# insure server stuff is installed
# include_recipe "memcached::default"
#
# instance name
instance_name = "testing"
#
memcached_instance instance_name do
  action :create
  bind_ip node[:memcached][:instance_name]
  port 11211
  max_connections 4096
  cachesize 4096
end
