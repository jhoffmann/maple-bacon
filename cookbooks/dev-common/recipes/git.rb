include_recipe 'git'
include_recipe 'root_ssh_agent::ppid'
include_recipe 'root_ssh_agent::env_keep'

apps = []
begin
  apps = data_bag("apps")
rescue
  puts "Unable to load apps data bag."
end

ssh_known_hosts_entry 'github.com'

# If the repo hasn't already been checked out, do so now
apps.each do |name|
  app = data_bag_item("apps", name)

  # Only checkout the repo if the directory exists
  if ( app['repo'] && File.directory?("#{node['apache']['docroot_dir']}/#{app['id']}/") )
    git "#{node['apache']['docroot_dir']}/#{app['id']}" do
      repository app['repo']
      revision app['branch']
      action :checkout
    end
  end
end
