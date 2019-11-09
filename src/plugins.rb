module Provision
  module Plugins
    def self.install_all
      required_plugins = %w( vagrant-disksize vagrant-vbguest )
      required_plugins.each do |plugin|
        exec "vagrant plugin install #{plugin} && vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
      end
    end
  end
end
