apps = []
begin
  apps = data_bag("apps")
rescue
  puts "Unable to load apps data bag."
end

# Configure apps
apps.each do |name|
  app = data_bag_item("apps", name)

  # Only setup the vhost if the directory exists
  if File.directory?("#{node['apache']['docroot_dir']}/#{app['id']}/")
    # Add app to apache config
    web_app app['id'] do
      server_name "#{app['id']}.#{node['app']['name']}.vm"
      allow_override 'all'
      docroot "#{node['apache']['docroot_dir']}/#{app['id']}/"
      notifies :restart, resources("service[apache2]"), :delayed
    end
  end
end
