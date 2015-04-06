name              'dev-applications'
description       'Application specific setup for Internal Applications'
version           '1.1.0'
maintainer        'John Hoffmann'
maintainer_email  'jhoffmann@sugarcrm.com'
license           'Copyright (C) SugarCRM Inc. All rights reserved.'

%w{ centos redhat }.each do |os|
  supports os
end

depends 'mysql', '~> 6.0'
depends 'java', '~> 1.31.0'
depends 'elasticsearch'
depends 'composer'
depends 'phing'