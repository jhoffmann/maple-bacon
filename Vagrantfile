PROJECT_NAME = 'dev'
BOX_MEMORY   = '2048'
IP_ADDRESS   = '192.168.3.14'

Vagrant.configure('2') do |config|
  config.vm.box = 'chef/centos-6.5'
  config.berkshelf.enabled = true

  # We are g'root!
  # config.ssh.username  = 'root'
  config.ssh.password  = 'vagrant'
  config.ssh.insert_key = 'true'
  config.ssh.forward_agent = true

  # This should allow us to use our host ssh keys for VM git operations

  # Set share folder
  config.vm.synced_folder '..', '/var/www/htdocs',
    owner: 'vagrant',
    group: 'vagrant',
    mount_options: ['dmode=775,fmode=664']

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.vm.define PROJECT_NAME do |node|
    node.vm.hostname = PROJECT_NAME + '.vm'
    node.vm.network :private_network, ip: IP_ADDRESS
    node.hostmanager.aliases = [
      'si.' + PROJECT_NAME + '.vm',
      'stock.' + PROJECT_NAME + '.vm',
      'internal.' + PROJECT_NAME + '.vm',
      'store.' + PROJECT_NAME + '.vm',
      'partners.' + PROJECT_NAME + '.vm',
      'gatekeeper.' + PROJECT_NAME + '.vm',
    ]
  end
  config.vm.provision :hostmanager

  config.vm.provider :virtualbox do |vb|
    vb.customize [
      'modifyvm', :id,
      '--memory', BOX_MEMORY,
      '--cpus', '1'
    ]
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = 'cookbooks'
    chef.data_bags_path = 'data_bags'

    # Common setup tasks
    chef.add_recipe 'dev-common'
    chef.add_recipe 'dev-common::vhosts'
    chef.add_recipe 'dev-common::git'
    chef.add_recipe 'dev-common::additional'

    # Application specific setup tasks
    chef.add_recipe 'dev-applications::stock'
    chef.add_recipe 'dev-applications::si'
    chef.add_recipe 'dev-applications::gatekeeper'

    chef.json = {
      :app => {
        :name => PROJECT_NAME
      }
    }
  end
end
