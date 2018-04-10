#
# Cookbook:: gl_mysql
# Recipe:: _enable_backup.rb
#
# Copyright:: 2017, The Authors, All Rights Reserved.
user node['gl_mysql']['backup']['user']
directory node['gl_mysql']['backup']['dir'] do
  mode '0750'
  owner node['gl_mysql']['backup']['user']
  action :create
end

cron 'app_prod backup' do
  minute '*'
  command %W(
    mysqldump -uroot
    -p#{node['gl_mysql']['mysql']['initial_root_password']}
    -S #{node['gl_mysql']['mysql']['unix_socket']}
    #{node['gl_mysql']['mysql']['prod_db_name']}
    | gzip -c > #{node['gl_mysql']['backup']['dir']}/#{node['gl_mysql']['mysql']['prod_db_name']}.`date "+\\%F.\\%H\\%M\\%S"`.sql.gz
  ).join(' ')
  action :create
end
