Description
===========
Adding cookbook to setup memcached.

Requirements
============

This cookbook CentOS.  Requires Chef 0.7.10 or higher for Lightweight Resource
and Provider support.  Chef 0.10 is recommended.

Packages
-------

- `memcached`

Attributes
==========

Several attributes make up the default behavior of this cookbook.  Override with
node-level attributes, or with recipes that call the LWRP directly.

* :memcached[:service_user] - user assigned ownership of daemon
* :memcached[:bind_ip] - ip address to bind to
* :memcached[:port] - port number to bind to
* :memcached[:max_connections] - maximum connections allowed to this instance
* :memcached[:cachesize] - how much memory to allocate to this instance (in MB)
* :memcached[:options] - any other command line options you want to provide

Lightweight Resources and Providers
===================================

memcached_instance
----------------

Deploys a Memcached instance.  The provider accepts attributes to override all
major defaults.

Actions:

* `create` - create an instance (default)

Usage
=====

```
instance_name = "example"

memcached_instance instance_name do
	action :create
	bind_ip node.ipaddress
    port 11212
    max_connections 2048
    cachesize 128
end
```
