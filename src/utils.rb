module Provision
  module Utils
    def self.get_display_info
      if Platform::os_type == Platform::WINDOWS
        description = `wmic path Win32_VideoController get VideoModeDescription`
        width, height, num_colors = description.match(/(\d+) x (\d+) x (\d+)/).captures
        color_depth = Math.log2(num_colors.to_i)
      else
        width = `xwininfo -root | grep Width:`.match(/.*:\s+(\d+)/).captures[0]
        height = `xwininfo -root | grep Height:`.match(/.*:\s+(\d+)/).captures[0]
        color_depth = `xwininfo -root | grep Depth:`.match(/.*:\s+(\d+)/).captures[0]
      end
      {
        'display_width' => width.to_i,
        'display_height' => height.to_i,
        'display_color_depth' => color_depth.to_i
      }
    end

    def self.clean_output_dir
      FileUtils.rm_rf(Dir.glob('out/*')) if File.directory?('out')
    end

    def self.load_external_steps(external_steps)
      external_steps.each do |script|
        require(File.expand_path(script))
      end
    end

    def self.provision_script(config, step, script)
      config.vm.provision "shell", privileged: false, path: "scripts/provision.sh", args: [step, script]
    end

    def self.provision_file(config, host_src, guest_dest)
      config.vm.provision "file", source: host_src, destination: guest_dest if File.exist?(File.expand_path(host_src))
    end
  end
end
