#
# Cookbook:: gl_mysql
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe "#{node['gl_mysql']['mysql']['repo']}"

prod_user = node['gl_mysql']['mysql']['prod_user']
prod_user_pass = node['gl_mysql']['mysql']['prod_user_pass']
stage_user = node['gl_mysql']['mysql']['stage_user']
stage_user_pass = node['gl_mysql']['mysql']['stage_user_pass']
init_root_password = node['gl_mysql']['mysql']['initial_root_password']

mysql_service node['gl_mysql']['mysql']['instance_name'] do
  version node['gl_mysql']['mysql']['version']
  port node['gl_mysql']['mysql']['port']
  initial_root_password init_root_password
  data_dir node['gl_mysql']['mysql']['datadir']
  socket node['gl_mysql']['mysql']['unix_socket']
  action [:create, :start]
end

mysql_config 'default' do
  instance node['gl_mysql']['mysql']['instance_name']
  source 'gl_mysql.cnf.erb'
  notifies :restart, "mysql_service[#{node['gl_mysql']['mysql']['instance_name']}]"
end

# Prerequisite for mysql2_chef_gem
# include_recipe 'build-essential'

# TODO: Below dependency of mysql_chef_gem.
# Should be revisited at some point
# after fixes in mysql or mysql2_chef_gem
#package 'mysql-community-devel' do
#  version node['carbonite_icinga2']['mysql']['community_devel_package_version']
#end


# Configure the MySQL client.
mysql_client 'default' do
  version node['gl_mysql']['mysql']['version']
  action :create
end

# Mysql2_chef_gem required to interact with mysql-service
mysql2_chef_gem 'default' do
  package_version '5.5.58-2'
  action :install
end

# Externalize mysql root connection that will be used to create users.
mysql_connection_info = {
  host: node['gl_mysql']['mysql']['host'],
  username: 'root',
  socket: node['gl_mysql']['mysql']['unix_socket'],
  password: init_root_password
}

# Create Prod Database
mysql_database node['gl_mysql']['mysql']['prod_db_name'] do
  connection mysql_connection_info
  action :create
end

# Create Stage Database
mysql_database node['gl_mysql']['mysql']['stage_db_name'] do
  connection mysql_connection_info
  action :create
end


# Grant access for prod user
mysql_database_user prod_user do
  connection mysql_connection_info
  password prod_user_pass
  database_name node['gl_mysql']['mysql']['prod_db_name']
  host node['gl_mysql']['mysql']['host']
  privileges [:create, :alter, :select, :insert, :update, :delete, :drop, 'create view', :index, :execute]
  action [:create, :grant]
end

# Grant access for prod user
mysql_database_user stage_user do
  connection mysql_connection_info
  password stage_user_pass
  database_name node['gl_mysql']['mysql']['stage_db_name']
  host node['gl_mysql']['mysql']['host']
  privileges [:create, :alter, :select, :insert, :update, :delete, :drop, 'create view', :index, :execute]
  action [:create, :grant]
end

# Grant access for prod user
mysql_database_user stage_user do
  connection mysql_connection_info
  password stage_user_pass
  database_name node['gl_mysql']['mysql']['prod_db_name']
  host node['gl_mysql']['mysql']['host']
  privileges [:select ]
  action [:grant]
end

# Place schema into tmp file on system:
cookbook_file "/tmp/classicmodels.sql"

# Load app_prod database schema
execute 'app_prod_schema_load' do
  command "\
  mysql -h #{node['gl_mysql']['mysql']['host']} \
  --socket=#{node['gl_mysql']['mysql']['unix_socket']}\
  -uroot \
  -p#{init_root_password} \
  #{node['gl_mysql']['mysql']['prod_db_name']} < /tmp/classicmodels.sql \
  && touch /var/lock/schema_loaded_app_prod"
  creates '/var/lock/schema_loaded_app_prod'
end

# Load app_stage database schema
execute 'app_stage_schema_load' do
  command "\
  mysql -h #{node['gl_mysql']['mysql']['host']} \
  --socket=#{node['gl_mysql']['mysql']['unix_socket']}\
  -uroot \
  -p#{init_root_password} \
  #{node['gl_mysql']['mysql']['stage_db_name']} < /tmp/classicmodels.sql \
  && touch /var/lock/schema_loaded_app_stage"
  creates '/var/lock/schema_loaded_app_stage'
end
