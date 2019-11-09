# -*- mode: ruby -*-
# vi: set ft=ruby :
require_relative 'src/plugins'
require_relative 'src/vbox_manage'
require_relative 'src/vm_config'
require_relative 'src/display'
require_relative 'src/vars'
require_relative 'src/runner'

Vagrant.require_version ">= 2.0.0"

Dir.mkdir('tmp') unless File.exists?('tmp')

vm_config = Provision::VMConfig::initialize_vm_configuration
display_info = Provision::Display::get_display_info
mounts = {'.provision' => '.'}.merge(vm_config.extra_mounts)
provision_vars = Provision::Vars::create_provision_vars(vm_config, display_info, mounts)

Vagrant.configure("2") do |config|
  config.trigger.before :all do |trigger|
    trigger.ruby {Provision::Plugins::install_all}
  end

  config.trigger.before :up, :reload, :provision do |trigger|
    trigger.ruby {Provision::VMConfig::print_configs}
  end

  config.trigger.before :up do |trigger|
    trigger.ruby do
      is_running = `vagrant status --machine-readable`.include? 'default,state,running'
      if is_running
        puts "Not proceeding with 'vagrant up' because Virtual Machine is already running."
        exit
      end
    end
  end

  config.vm.box = "ubuntu/eoan64"
  config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.ssh.forward_agent = true
  config.disksize.size = "#{vm_config.disk_space}GB"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.name = vm_config.vm_name
    vb.customize ["modifyvm", :id, "--vrde", "off"]
    vb.customize ["modifyvm", :id, "--hpet", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--cpus", vm_config.processors]
    vb.customize ["modifyvm", :id, "--memory", vm_config.base_memory]
    vb.customize ["modifyvm", :id, "--vram", vm_config.video_memory]
    vb.customize ["modifyvm", :id, "--monitorcount", vm_config.monitor_count]
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vboxsvga"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    vb.customize ['modifyvm', :id, '--draganddrop', 'bidirectional']
    vb.customize ["modifyvm", :id, "--usbxhci", "on"]

    Provision::VBoxManage::mount_folders vb, mounts
  end

  Provision::Runner::run(:prepare, config, provision_vars)
  Provision::Runner::run(:configure, config, provision_vars)

  if vm_config.restart
    config.trigger.after :up do |trigger|
      trigger.ruby do
        Provision::VBoxManage::configure_resolution(vm_config.vm_name, display_info)
        exec "vagrant reload --no-provision"
      end
    end
  end
end
