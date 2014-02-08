action :create do

  template "#{node[:memcached][:config_dir]}/memcached-#{new_resource.name}" do
    source "memcached-sysconfig.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(
      :bind_ip => new_resource.bind_ip,
      :port => new_resource.port,
      :service_user => new_resource.service_user,
      :max_connections => new_resource.max_connections,
      :cachesize => new_resource.cachesize,
      :options => new_resource.options,
      :instance_name => new_resource.name
    )
  end

  template "#{node[:memcached][:init_dir]}/memcached-#{new_resource.name}" do
    source "memcached-init.erb"
    owner "root"
    group "root"
    mode "0755"
    variables(
      :instance_name => new_resource.name
    )
    action :create
  end

  service "memcached-#{new_resource.name}" do
    action [ :enable, :start ]
    supports :restart => true, :start => true, :stop => true, :status => true
  end

  # My state has changed so I'd better notify observers
  new_resource.updated_by_last_action(true)

end
