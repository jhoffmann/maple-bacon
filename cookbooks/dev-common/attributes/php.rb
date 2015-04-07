# This tells the community php cookbook to use our custom php.ini template
override['php']['ini']['cookbook'] = 'dev-common'
override['phpunit']['install_method'] = 'phar'
override['phpunit']['install_dir'] = '/usr/local/bin'

# These get added to the end of the php.ini file, so you can add whatever you need here
default['php']['conf_dir'] = '/etc'
default['php']['directives']['date.timezone']        = 'PST8PDT'
default['php']['directives']['session.save_path']    = 'localhost:11211'
default['php']['directives']['session.save_handler'] = 'memcached'
default['php']['directives']['error_log']            = "#{node['apache']['docroot_dir']}/php_errors.log"

# These are the suggested values for running Sugar7
default['php']['directives']['memory_limit']         = '256M'
default['php']['directives']['post_max_size']        = '50M'
default['php']['directives']['upload_max_filesize']  = '50M'
