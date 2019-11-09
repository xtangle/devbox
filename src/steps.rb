require_relative 'vars'

module Provision
  module Steps
    def self.prepare(config, provision_vars)
      # adds user to vboxsf group so that shared folders can be accessed;
      # kills the ssh daemon to reset the ssh connection and allow user changes to take effect
      config.vm.provision "shell", inline: "adduser vagrant vboxsf && pkill -u vagrant sshd"
      config.vm.provision "shell", inline: Vars::prepare_provision_vars(provision_vars)
      config.vm.provision "shell", privileged: false, path: "scripts/configure/configure-mounts.sh"

      if File.exist?("#{ENV['userprofile']}\\.git-credentials") || File.exist?("#{ENV['HOME']}/.git-credentials")
        config.vm.provision "file", source: "~/.git-credentials", destination: "~/.git-credentials"
      end
    end

    def self.configure(config, provision_vars)
      config.vm.provision "shell", privileged: false, path: "scripts/provision.sh"

      provision_vars['extra_scripts'].each do |path|
        config.vm.provision "shell", privileged: false, path: path
      end
    end
  end
end
