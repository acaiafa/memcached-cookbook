#
# Cookbook Name:: memcached
# Attributes:: default
#

default[:memcached][:bind_ip] = "127.0.0.1"

default[:memcached][:port] = "11211"

default[:memcached][:max_connections] = "1024"

default[:memcached][:cachesize] = "64"

default[:memcached][:service_user] = "memcached"

default[:memcached][:options] = ""

default[:memcached][:init_dir] = "/etc/init.d"


case node[:platform_family]
when  'centos', 'redhat', 'amazon', 'scientific'
  default[:memcached][:config_dir] = "/etc/sysconfig"
  default[:memcached][:init_dir] = "/etc/init.d"
when 'ubuntu', 'debian'
  default[:memcached][:config_dir] = "/etc"
  default[:memcached][:options_dir] = "/etc/default"
end
