default['dev']['database'] = {
  'host' => '10.0.2.2',
  'username' => 'root',
  'password' => 'root'
}

default['dev']['mysql-server'] = {
  'version'  => '5.6',
  'password' => node['dev']['database']['password']
}

default['java']['install_flavor'] = 'openjdk'
default['java']['jdk_version'] = '7'

default['elasticsearch']['plugins'] = {
  'mobz/elasticsearch-head' => {}
}

# We don't want the composer running php::default as it will install php 5.3
# and fail, because it conflicts with our installed php 5.4
override['composer']['php_recipe'] = 'php::ini'

if File.exists?('local.rb')
  include_attribute 'dev-applications::local'
end

