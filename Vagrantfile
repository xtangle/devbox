# -*- mode: ruby -*-
# vi: set ft=ruby :
require_relative 'src/manage'
require_relative 'src/config'
require_relative 'src/utils'
require_relative 'src/vars'
require_relative 'src/runner'

Vagrant.require_version ">= 2.0.0"

FileUtils.mkdir_p('out')
vm_config = Provision::Config::initialize_vm_configuration
provision_vars = Provision::Vars::create_provision_vars(vm_config)

Vagrant.configure("2") do |config|
  config.vagrant.plugins = %w( vagrant-disksize vagrant-vbguest )

  config.trigger.before :up, :reload, :provision do |trigger|
    trigger.ruby {Provision::Config::print_configs}
    trigger.ruby {Provision::Utils::clean_output_dir}
    trigger.ignore = [:destroy, :halt]
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

  config.vm.box = "xtangle/pop_os-20.10"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 4200, host: 4200
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.boot_timeout = 600
  config.ssh.forward_agent = true
  config.disksize.size = "#{vm_config.disk_space}GB"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.name = vm_config.vm_name
    vb.customize ['modifyvm', :id, '--vrde', 'off']
    vb.customize ['modifyvm', :id, '--hpet', 'on']
    vb.customize ['modifyvm', :id, '--ioapic', 'on']
    vb.customize ['modifyvm', :id, '--cpus', vm_config.processors]
    vb.customize ['modifyvm', :id, '--memory', vm_config.base_memory * 1024]
    vb.customize ['modifyvm', :id, '--vram', vm_config.video_memory]
    vb.customize ['modifyvm', :id, '--monitorcount', vm_config.monitor_count]
    vb.customize ['modifyvm', :id, '--hwvirtex', 'on']
    vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
    vb.customize ['modifyvm', :id, '--accelerate3d', 'off']
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    vb.customize ['modifyvm', :id, '--draganddrop', 'bidirectional']
    vb.customize ['modifyvm', :id, '--usbehci', 'on']
    vb.customize ['modifyvm', :id, '--uartmode1', 'file', File.join(Dir.pwd, 'out/ubuntu-cloudimg-console.log')]
    Provision::Manage::mount_folders vb, provision_vars['mounts']
  end

  Provision::Runner::load_extra_steps(provision_vars['extra_steps'])
  Provision::Runner::run(config, provision_vars)
end
