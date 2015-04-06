name              'dev-common'
description       'Environment setup for Internal Applications'
version           '1.1.0'
maintainer        'John Hoffmann'
maintainer_email  'jhoffmann@sugarcrm.com'
license           'Copyright (C) SugarCRM Inc. All rights reserved.'

%w{ centos redhat }.each do |os|
  supports os
end

depends 'yum'
depends 'yum-epel'
depends 'yum-ius'
depends 'yum-centos'
depends 'build-essential'
depends 'vim'
depends 'curl'
depends 'openssl'
depends 'apache2'
depends 'git'
depends 'ssh_known_hosts'
depends 'php'

