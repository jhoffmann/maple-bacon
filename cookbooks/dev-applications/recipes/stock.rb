template "#{node['apache']['docroot_dir']}/stock/config_si.php" do
  source 'config_si.php.erb'
  unless platform?('windows')
    owner 'root'
    group 'root'
    mode '0644'
  end
  variables(:directives => node['stock']['config'])
end

# Install the mysql server
config = node['dev']['mysql-server']
mysql_service 'default' do
  version               config['version']
  initial_root_password config['password']
  socket                '/var/lib/mysql/mysql.sock'
  action [:create, :start]
end

# Use our custom config file tweaked for innodb performance
mysql_config 'default' do
  source 'my.cnf.erb'
  notifies :restart, 'mysql_service[default]'
  action :create
end

# Install the mysql client
mysql_client 'default' do
  action :create
end
