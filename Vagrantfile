# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box      = 'ubuntu/trusty64'
  config.vm.hostname = 'ror-devbox'

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.network :forwarded_port, guest: 8090, host: 8090

  config.vm.provision :shell, path: 'provision.sh', keep_color: true
  # config.vm.provision :shell, path: 'startup.sh', run: 'always', privileged: false

  # config.trigger.after :provision, :execute => "vagrant reload"

  config.vm.provider 'virtualbox' do |v|
    v.memory = 1024
    v.cpus = 2
  end
end
