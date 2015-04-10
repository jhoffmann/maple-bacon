include_attribute 'dev-common::apache'
include_attribute 'dev-common::php'

override['hosts_file']['custom_entries'] = {
  "#{node['network']['default_gateway']}" => "parent"
}

if File.exists?('local.rb')
  include_attribute 'dev-common::local'
end
