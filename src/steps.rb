require_relative 'vars'
require_relative 'utils'

module Provision
  module Steps
    def self.prepare(config, provision_vars)
      # adds user to vboxsf group so that shared folders can be accessed;
      # kills the ssh daemon to reset the ssh connection and allow user changes to take effect
      config.vm.provision "shell", inline: "adduser vagrant vboxsf && pkill -u vagrant sshd"
      config.vm.provision "shell", inline: Vars::prepare_provision_vars(provision_vars)

      Utils::provision_file(config, '~/.git-credentials', '~/.git-credentials')
      Utils::provision_script(config, 'prepare', '${HOME}/.provision/scripts/prepare/prepare-devbox.sh')
      Utils::provision_script(config, 'prepare', '${HOME}/.provision/scripts/prepare/prepare-mounts.sh')
      Utils::provision_script(config, 'prepare', '${HOME}/.provision/scripts/prepare/prepare-system.sh')
      Utils::provision_script(config, 'prepare', '${HOME}/.provision/scripts/prepare/prepare-utils.sh')
      Utils::provision_script(config, 'prepare', '${HOME}/.provision/scripts/prepare/prepare-user.sh')
    end

    def self.install(config, provision_vars)
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-kde.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-nvm.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-yarn.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-java.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-maven.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-clojure.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-sbt.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-kotlin.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-python.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-ruby.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-go.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-haskell.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-rust.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-erlang.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-elixir.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-latex.sh')

      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-git.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-sublime.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-intellij.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-vscode.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-docker.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-docker-compose.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-chrome.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-firefox.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-confluent.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-fonts.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-tilda.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-postman.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-libreoffice.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-evince.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-viewnior.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-meld.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-dbeaver.sh')
      Utils::provision_script(config, 'install', '${HOME}/.provision/scripts/install/install-remmina.sh')
    end

    def self.configure(config, provision_vars)
      # config.vm.provision "shell", privileged: false, path: "scripts/provision.sh"
      #
      # provision_vars['extra_scripts'].each do |path|
      #   config.vm.provision "shell", privileged: false, path: path
      # end
    end

    def self.cleanup(config, provision_vars)

    end
  end
end
