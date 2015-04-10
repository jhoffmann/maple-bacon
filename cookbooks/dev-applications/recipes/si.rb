include_recipe 'java'
include_recipe 'elasticsearch'
include_recipe 'elasticsearch::plugins'

# We can't use the memcached cookbook as it installs an older version of libmemcached,
# while our php54 packages (specifically php54-pecl-memcached) require libmemcached10
service 'memcached' do
  supports :status => true, :restart => true, :reload => true
  action [:enable]
end
