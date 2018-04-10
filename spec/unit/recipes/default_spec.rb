#
# Cookbook:: gl_mysql
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'gl_mysql::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8')
      runner.converge(described_recipe)
    end

    it 'creates and configure mysql service' do
      expect(chef_run).to create_mysql_service('default')
      expect(chef_run).to create_mysql_config('default')
    end

    it 'install mysql2_chef_gem' do
      expect(chef_run).to install_mysql2_chef_gem('default')
    end

    it 'creates and configure mysql client' do
      expect(chef_run).to create_mysql_client('default')
    end

    it 'creates prod database and user' do
      expect(chef_run).to create_mysql_database('app_prod')
      expect(chef_run).to create_mysql_database_user('prod_user')
    end

    it 'creates stage database and user' do
      expect(chef_run).to create_mysql_database('app_stage')
      expect(chef_run).to create_mysql_database_user('stage_user')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
