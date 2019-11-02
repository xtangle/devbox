module Vars
  def self.prepare_provision_vars(vm_config, display_info, mounts)
    env_vars = [*vm_config.to_hash, *display_info, *{'mounts' => mounts}].map{|k, v| ["PROVISION_#{k.upcase}", v]}.to_h

    setup_cmds = []

    env_vars.each { |key, value|
      if value.instance_of? Array
        setup_cmds.push("declare -agx #{key}=(#{value.map { |v| "\\\"#{Shellwords.escape(v)}\\\"" }.join(' ')})")
      elsif value.instance_of? Hash
        # supports only 1 level of nested objects for now
        setup_cmds.push("declare -Agx #{key}=(#{value.map { |k, v| "[\\\"#{k}\\\"]=\\\"#{Shellwords.escape(v)}\\\"" }.join(' ')})")
        # add additional array to keep track of original hash order
        setup_cmds.push("declare -agx #{key}_KEYS=(#{value.map { |k, _| "\\\"#{k}\\\"" }.join(' ')})")
      else
        setup_cmds.push("export #{key}=#{Shellwords.escape(value)}")
      end
    }

    description = "# NOTE: DO NOT REMOVE.\n# This file contains variables used for provisioning and mounting and is needed when VM starts up.\n# Source this file in scripts when needed."
    content = "#{description}\n\n#{setup_cmds.join('\n')}\n"

    <<-EOS
      mkdir -p "/home/vagrant/devbox/out"
      printf "#{content}" > "/home/vagrant/devbox/out/provision-vars.sh"
      chown -R vagrant "/home/vagrant/devbox/out"
    EOS
  end
end
