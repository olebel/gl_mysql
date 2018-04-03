### Lab #5 MySQL Cookbook using Community Code.
1. Generate cookbook with `chef generate cookbook` command
2. Specify dependencies in **metadata.rb**
3. Set-Up MySQL server 5.5. Use CentOS 6.9 platform.
4. Create MySQL database `app_prod`. Create MySQL user `prod_user`. Grant all privileges to `prod_user` on `app_prod`
5. Create MySQL database `app_stage`. Create MySQL user `stage_user`. Grant all privileges to `stage_user` on `app_stage` Db. Grant select privilege to `stage_user` on `app_prod`.
6. Create schemas on `app_prod` , `app_stage` using sample schema *sample_schema.sql*
7. Create backup folder : `'/opt/backups'`
8. Create daily cronjob with backup of each DB.
9. Tune `innod_db_buffer_pool_size` to be `1024Mb`. Keep as string parameter ( cookbook attribute )


### Dependencies:
* `mysql` : https://github.com/chef-cookbooks/mysql
* `database`: https://github.com/chef-boneyard/database
