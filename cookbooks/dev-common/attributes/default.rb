include_attribute 'dev-common::apache'
include_attribute 'dev-common::php'

if File.exists?('local.rb')
  include_attribute 'dev-common::local'
end
