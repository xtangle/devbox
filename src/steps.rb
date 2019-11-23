require_relative 'vars'
require_relative 'utils'

module Provision
  module Steps
    DEVBOX_SCRIPTS_DIR = '${HOME}/.provision/scripts'

    def self.prepare(config, provision_vars)
      # adds user to vboxsf group so that shared folders can be accessed;
      # kills the ssh daemon to reset the ssh connection and allow user changes to take effect
      config.vm.provision "shell", inline: "adduser vagrant vboxsf && pkill -u vagrant sshd"
      config.vm.provision "shell", inline: Vars::prepare_provision_vars(provision_vars)

      Utils::provision_file(config, '~/.git-credentials', '~/.git-credentials')
      Utils::provision_script(config, 'prepare', "#{DEVBOX_SCRIPTS_DIR}/prepare/prepare-devbox.sh")
      Utils::provision_script(config, 'prepare', "#{DEVBOX_SCRIPTS_DIR}/prepare/prepare-mounts.sh")
      Utils::provision_script(config, 'prepare', "#{DEVBOX_SCRIPTS_DIR}/prepare/prepare-system.sh")
      Utils::provision_script(config, 'prepare', "#{DEVBOX_SCRIPTS_DIR}/prepare/prepare-utils.sh")
      Utils::provision_script(config, 'prepare', "#{DEVBOX_SCRIPTS_DIR}/prepare/prepare-user.sh")
    end

    def self.install(config, provision_vars)
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-kde.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-nvm.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-yarn.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-java.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-maven.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-clojure.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-sbt.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-kotlin.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-python.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-ruby.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-go.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-haskell.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-rust.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-erlang.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-elixir.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-latex.sh")

      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-git.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-sublime.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-intellij.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-vscode.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-docker.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-docker-compose.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-chrome.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-firefox.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-confluent.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-fonts.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-tilda.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-postman.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-libreoffice.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-evince.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-viewnior.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-meld.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-dbeaver.sh")
      Utils::provision_script(config, 'install', "#{DEVBOX_SCRIPTS_DIR}/install/install-remmina.sh")
    end

    def self.cleanup(config, provision_vars)
      Utils::provision_script(config, 'cleanup', "#{DEVBOX_SCRIPTS_DIR}/cleanup/cleanup-system.sh")
    end
  end
end
