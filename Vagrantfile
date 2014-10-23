# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'hashicorp/precise64'

  config.vm.network 'forwarded_port', guest: 8080, host: 8080

  config.vm.network "private_network", type: "dhcp"
  config.vm.synced_folder '.', '/vagrant', type: 'nfs'

  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['modifyvm', :id, '--memory', '1024']
  end

  config.vm.provision 'shell', path: 'bin/vagrant/base.sh'
  config.vm.provision 'shell', path: 'bin/vagrant/ruby-2.1.sh', privileged: false, keep_color: true
end