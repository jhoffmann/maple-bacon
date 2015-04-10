default['stock']['config'] = {
  'setup_db_host_name'         => node['dev']['database']['host'],
  'setup_db_admin_user_name'   => node['dev']['database']['username'],
  'setup_db_admin_password'    => node['dev']['database']['password'],
  'setup_db_database_name'     => 'stock',
  'setup_site_admin_user_name' => 'Admin',
  'setup_site_admin_password'  => 'zxcv',
  'setup_site_url'             => 'http://stock.dev.vm',
  'setup_fts_type'             => 'Elastic',
  'setup_fts_host'             => 'localhost',
  'setup_fts_port'             => '9200',
}

if File.exists?('local.rb')
  include_attribute 'dev-applications::local'
end
