# -*- mode: ruby -*-
# vi: set ft=ruby :
require_relative 'src/plugins'
require_relative 'src/vbox_manage'
require_relative 'src/vm_config'
require_relative 'src/display'

Vagrant.require_version ">= 2.0.0"

VBoxManage::ensure_cmd_exists
vm_config = VMConfig::initialize_vm_configuration
display_info = Display::get_display_info
env_vars = vm_config.to_hash.merge(display_info).map{|k, v| [k.upcase, v]}.to_h
has_provisioned = VBoxManage::has_provisioned vm_config.vm_name

Vagrant.configure("2") do |config|
  config.trigger.before :all do |trigger|
    trigger.ruby {Plugins::install_all}
  end

  config.trigger.before :up, :reload, :provision do |trigger|
    trigger.ruby {VMConfig::print_configs}
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

  config.vm.box = "ubuntu/bionic64"
  config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "private_network", ip: "192.168.33.10"
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
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    vb.customize ['modifyvm', :id, '--draganddrop', 'bidirectional']
    vb.customize ["modifyvm", :id, "--usbxhci", "on"]

    VBoxManage::mount_folders vb, {
      :"Projects" => "..",
      :"vagrant-files" => "files",
      :"vagrant-scripts" => "scripts"
    } unless has_provisioned
  end

  config.vm.synced_folder ".", "/vagrant", disabled: true

  if File.exist?("#{ENV['userprofile']}\\.git-credentials") || File.exist?("#{ENV['HOME']}/.git-credentials")
    config.vm.provision "file", run: "always", source: "~/.git-credentials", destination: "~/.git-credentials"
  end

  # adds user to vboxsf group so that shared folders can be accessed;
  # kills the ssh daemon to reset the ssh connection and allow user changes to take effect
  config.vm.provision "shell", inline: "adduser vagrant vboxsf && pkill -u vagrant sshd"
  config.vm.provision "shell", run: "always", privileged: false, env: env_vars, path: "scripts/provision.sh"

  vm_config.extra_provision_scripts.each do |path|
    config.vm.provision "shell", run: "always", privileged: false, env: env_vars, path: path
  end

  if vm_config.restart
    config.trigger.after :up do |trigger|
      trigger.ruby do
        VBoxManage::configure_resolution(vm_config.vm_name, display_info)
        exec "vagrant reload --no-provision"
      end
    end
  end
end
