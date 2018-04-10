# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'.freeze

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'bento/centos-6.9'

  config.vbguest.auto_update = false
  config.omnibus.chef_version = '12.19.36'

  config.vm.define 'lab5' do |lab5|
    lab5.vm.hostname = 'lab5.local'
    lab5.vm.provision 'chef_solo' do |chef|
      chef.add_recipe 'gl_mysql'
      chef.add_recipe 'gl_mysql::_enable_backup'
    end
  end
end
