include_recipe "nodejs"

mysql2_chef_gem 'default' do
  action :install
end

nodejs_npm "bower" do
end

nodejs_npm "grunt-cli" do
end

execute 'Have bower install dependencies' do
  user 'vagrant'
  command 'bower install'
  action :run
  # not_if { ::File.directory?('/etc/postgresql/' + node['postgresql']['version'] + '/main') }
end
