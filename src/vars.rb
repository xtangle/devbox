module Provision
  module Vars
    def self.create_provision_vars(vm_config, display_info, mounts)
      [*vm_config.to_hash, *display_info, *{'mounts' => mounts}].to_h
    end

    def self.prepare_provision_vars(provision_vars)
      uppercased = provision_vars.map{|k, v| ["PROVISION_#{k.upcase}", v]}.to_h
      setup_cmds = []

      uppercased.each { |key, value|
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
      file = "/home/vagrant/.load-provision-vars.sh"

      <<-EOS
        printf "#{content}" > "#{file}"
        chown vagrant "#{file}"
        chmod 775 "#{file}"
        mkdir -p "/vagrant/out"
        cp -f "#{file}" "/vagrant/out"
      EOS
    end
  end
end
