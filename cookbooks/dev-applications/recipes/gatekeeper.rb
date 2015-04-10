include_recipe "nodejs"

mysql2_chef_gem 'default' do
  action :install
end

nodejs_npm "bower" do
end

nodejs_npm "grunt-cli" do
end
