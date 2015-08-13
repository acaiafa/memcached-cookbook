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

      def action_enable
        notifying_block do
          # Install memcached package 
          package "memcached" do
            action :install
          end

          file "/etc/memcached.conf" do
            action :delete
          end

          template "#{new_resource.instance} :create #{config_dir}/#{file_name}#{new_resource.instance}.conf" do
            path "#{config_dir}/#{file_name}#{new_resource.instance}.conf"
            source "memcached-config-#{node.platform_family}.erb"
            user "root"
            group "root"
            variables(config: new_resource)
            cookbook "memcached"
          end
        end
        super
      end

      def action_delete
        super 
        notifying_block do 
          directory "#{config_dir}/#{file_name}#{new_resource.instance}.conf" do
            action :delete
          end
        end
      end

      def service_options(service)
        service.service_name("memcached")
        service.command(start_command)
        service.directory('/var/run')
        service.user(new_resource.service_user)
        service.restart_on_update(true)
      end
    end
  end
end
