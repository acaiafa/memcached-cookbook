module MemcachedCookbook
  module Helpers
    include Chef::DSL::IncludeRecipe

    def config_dir
      case node.platform_family
      when "rhel"
        "/etc/sysconfig"
      else
        "/etc"
      end
    end

    def file_name
      case node.platform_family
      when "rhel"
        "memcached-"
      else
        "memcached_"
      end
    end

    def start_command
      start = "/usr/bin/memcached -d -m #{new_resource.cachesize} -p #{new_resource.port} -u #{new_resource.service_user} -l #{new_resource.bind_ip} -c #{new_resource.max_connections} -P /var/run/memcached.pid"
      case new_resource.options
      when true
        "#{start} #{options}"
      when false
        "#{start}"
      end
    end

  end
end
