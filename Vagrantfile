# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box      = 'precise64'
  config.vm.box_url  = 'http://files.vagrantup.com/precise64.box'
  config.vm.hostname = 'collectd.example.org'

  config.vm.network "forwarded_port", guest: 80, host: 3000

  config.vm.synced_folder "dist/templates", "/tmp/vagrant-puppet/templates"

  config.vm.provision :puppet do |puppet|
    puppet.module_path    = 'dist/modules'
    puppet.manifests_path = 'dist/manifests'
    puppet.manifest_file  = 'site.pp'
    puppet.options        = ["--templatedir","/tmp/vagrant-puppet/templates"]
  end

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end
end

