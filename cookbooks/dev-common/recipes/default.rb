include_recipe 'yum'
include_recipe 'yum-epel'
include_recipe 'yum-ius'
include_recipe 'yum-centos'
include_recipe 'build-essential'
include_recipe 'vim'
include_recipe 'curl'
include_recipe 'openssl'
include_recipe 'apache2'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_autoindex'

apps = []
begin
  apps = data_bag("apps")
rescue
  puts "Unable to load apps data bag."
end

# Install any additional packages configured in the app json files
apps.each do |name|
  app = data_bag_item("apps", name)
  app['packages'].each do |a_package|
    package a_package
  end
end

include_recipe "php::ini"

bash 'enable php' do
  code <<-EOF
  mv #{node['apache']['dir']}/conf.d/php.conf #{node['apache']['dir']}/conf-available/php.conf
  a2enconf php
  EOF
  not_if { ::File.exists?("#{node['apache']['dir']}/conf-available/php.conf") }
end

php_pear_channel 'pear.php.net' do
  action :update
end

php_pear_channel 'pecl.php.net' do
  action :update
end

php_pear 'jsmin' do
  action :install
end

php_pear 'APC' do
  action :install
  directives(:shm_size => '150M', :enable_cli => 0)
end
