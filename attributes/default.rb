default['gl_mysql']['mysql']['prod_user'] = "prod_user"
default['gl_mysql']['mysql']['prod_user_pass'] = "password"
default['gl_mysql']['mysql']['stage_user'] = "stage_user"
default['gl_mysql']['mysql']['stage_user_pass'] = "stage_password"
default['gl_mysql']['mysql']['prod_db_name'] = "app_prod"
default['gl_mysql']['mysql']['stage_db_name'] = "app_stage"

default['gl_mysql']['mysql']['host'] = 'localhost'
default['gl_mysql']['mysql']['instance_name']="default"
default['gl_mysql']['mysql']['version']="5.5"
default['gl_mysql']['mysql']['port']="3306"
default['gl_mysql']['mysql']['initial_root_password'] = 'root'
default['gl_mysql']['mysql']['datadir'] = '/opt/default/data'
default['gl_mysql']['mysql']['unix_socket'] = '/var/lib/mysql/mysql.sock'

default['gl_mysql']['mysql']['repo'] = "yum-mysql-community::mysql55"
default['gl_mysql']['mysql']['innodb_buffer_pool_size'] = "1048576"

default['gl_mysql']['backup']['user']='mysql_backup'
default['gl_mysql']['backup']['dir']="/opt/backups"
