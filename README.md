Description
===========
Adding cookbook to setup memcached.

Requirements
------------

This cookbook supports Debian/RHEL systems.  Requires Chef 0.7.10 or higher for Lightweight Resource
and Provider support. 


#### Packages


- `memcached`

Attributes
----------

Several attributes make up the default behavior of this cookbook.  Override with
node-level attributes, or with recipes that call the LWRP directly.

* :memcached[:service_user] - user assigned ownership of daemon
* :memcached[:bind_ip] - ip address to bind to
* :memcached[:port] - port number to bind to
* :memcached[:max_connections] - maximum connections allowed to this instance
* :memcached[:cachesize] - how much memory to allocate to this instance (in MB)
* :memcached[:options] - any other command line options you want to provide

Lightweight Resources and Providers
-----------------------------------

#### memcached_instance


Deploys a Memcached instance.  The provider accepts attributes to override all
major defaults.

Actions:

* `create` - create an instance (default)


Usage
-----
There is an example recipe called testing.rb. However here is another example.
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

OHAI Attribute
--------------
I put together an OHAI attribute that allows you to create a node attribute called memcached[:instance_name]. You will have to add the instance names to this file.  Here is the code for the OHAI attribute.  If you have a better way of doing this please lets change it around. The get_int_info will also need to be specific to you. 
```
#memcached ips
provides "memcache"
memcache Mash.new
##get info
get_int_info = %x{ip addr |grep -i 'eth0:' |awk '{print $2, $8}'|sed 's/\\/16//' |sed 's/eth0://g'}
##split_data
split_int_info = get_int_info.split().reverse
##create hash
int_info = Hash[*split_int_info]

    int_info.each do |int,ip|
        memcache[:instance_name_here] = ip if int.include?("instance_name_here")
        memcache[:instance_name_here] = ip if int.include?("instance_name_here")
        memcache[:instance_name_here] = ip if int.include?("instance_name_here")
    end
```
Basically all this does is runs a command to find your IP info on your machine your deploying this cookbook to. You will add whatever interface you normally use to this attribute at the top. The way I did my interface naming convention for my memcached nodes was very simple "eth0:instance_name". This made it very easy for me to add multiple instances to the same host and have different start scripts for each. There is slight manual intervention but this is no means a perfect cookbook just something that worked.


License & Authors
-------
- Author:: Anthony Caiafa (<2600.ac@gmail.com>)

```
The MIT License (MIT)

Copyright (c) 2014 Anthony Caiafa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
