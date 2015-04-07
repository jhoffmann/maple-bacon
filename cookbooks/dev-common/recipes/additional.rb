include_recipe 'composer'
include_recipe 'phing::composer'
include_recipe 'phpunit'

# These have to happen after PHP is setup in the default recipe
