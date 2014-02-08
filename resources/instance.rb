#
# Cookbook Name:: memcached
# Resource:: instance
#

actions :create
default_action :create

# memcached attributes
attribute :bind_ip,			:kind_of => String, :default => '127.0.0.1'
attribute :port,			:kind_of => Integer, :default => 11211
attribute :max_connections,	:kind_of => Integer, :default => 1024
attribute :cachesize,		:kind_of => Integer, :default => 64
attribute :service_user,	:kind_of => String, :default => 'memcached'
attribute :options,			:kind_of => String
