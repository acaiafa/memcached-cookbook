#
## Cookbook: memcached-cookbook
## License: Apache 2.0
#

require 'poise_service/service_mixin'
require_relative 'helpers'

module MemcachedCookbook
  module Resource
    class MemcachedInstance < Chef::Resource
      include Poise
      provides(:memcached_instance)
      include PoiseService::ServiceMixin
      actions(:create, :delete)
      default_action(:create)


      # @!attribute config_name
      # @return [String]
      attribute(:instance, kind_of: String, name_attribute: true)

      attribute(:bind_ip, kind_of: String, default:  '127.0.0.1')
      attribute(:port, kind_of:  Integer, default:  11211)
      attribute(:max_connections, kind_of:  Integer, default:  1024)
      attribute(:cachesize, kind_of:  Integer, default:  64)
      attribute(:service_user, kind_of:  String, default:  'memcache')
      attribute(:enabled, equal_to: %w{yes no},  default:  'yes')
      attribute(:options, kind_of: [String, NilClass], default: nil)

    end
  end

  module Provider 
    class MemcachedInstance < Chef::Provider
      include Poise
      provides(:memcached_instance)
      include PoiseService::ServiceMixin
      include MemcachedCookbook::Helpers

      def action_create
        notifying_block do
          # Install memcached package 
          package "memcached" do
            action :install
          end

          file "/etc/memcached.conf" do
            action :delete
          end

          template "#{new_resource.instance} :create #{config_dir}/#{file_name}#{new_resource.instance}" do
            path "#{config_dir}/#{file_name}#{new_resource.instance}.conf"
            source "memcached-config-#{node.platform_family}.erb"
            user "root"
            group "root"
            variables(
              config: new_resource
            )
            cookbook "memcached"
          end
        end
      end

      def action_delete
        notifying_block do 
          directory config_dir do
            action :delete
          end
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


      def service_options
        service.service_name("memcached-#{new_resource.instance}")
        service.command(start_command)
        service.directory('/var/run')
        service.user(new_resource.service_user)
        service.restart_on_update(true)
      end
    end
  end
end
