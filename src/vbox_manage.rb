require_relative './platform'

module Provision
  module VBoxManage
    def self.box_exists?(vm_name)
      system("\"#{VBOX_MANAGE_CMD}\" showvminfo #{vm_name}", out: File::NULL, err: File::NULL)
    end

    def self.mount_folders(vb, name_path_hash)
      vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/SharedFolders/MountPrefix", ""]
      vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/SharedFolders/MountDir", "/home/vagrant"]
      name_path_hash.each do |name, path|
        vb.customize ["sharedfolder", "add", :id, "--name", name, "--hostpath", host_mount_path(path), "--automount"]
        vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/#{name}", "1"]
      end
    end

    def self.configure_resolution(vm_name, display_info)
      if box_exists?(vm_name)
        system("\"#{VBOX_MANAGE_CMD}\" controlvm #{vm_name} setevideomodehint #{display_info[:display_width]} #{display_info[:display_height]} #{display_info[:display_color_depth]} #{hide_cmd_output}")
      end
    end

    private

    def self.host_mount_path(rel_path)
      abs_path = File.expand_path(rel_path)
      if Platform::os_type == Platform::WINDOWS
        abs_path = abs_path.gsub('/', '\\')
        # if there is backslash at the end, then add extra backslashes to prevent the end quote from being unintentionally escaped
        if abs_path.end_with?('\\')
          abs_path = "#{abs_path}\\\\\\"
        end
      end
      abs_path
    end
    private_class_method :host_mount_path

    def self.hide_cmd_output
      if Platform::os_type == Platform::WINDOWS
        '>nul 2>&1'
      else
        '>/dev/null 2>&1'
      end
    end
    private_class_method :hide_cmd_output

    def self.list_shared_folder_names(vm_name)
      vminfo_lines = `"#{VBOX_MANAGE_CMD}" showvminfo #{vm_name}`.split(/\n/)
      sf_index = vminfo_lines.index { |l| l.strip == 'Shared folders:' }
      if sf_index.nil?
        return []
      end
      sf_index = sf_index + 2 # first shared folder info starts 2 lines down
      sf_names = []
      loop do
        sf_line = vminfo_lines[sf_index]
        break if sf_line.empty? || sf_line.strip == '<none>'
        sf_name = sf_line.match(/Name: '([^']*)'.*/).captures[0]
        sf_names.push(sf_name)
        sf_index += 1
      end
      sf_names
    end
    private_class_method :list_shared_folder_names

    VBOX_MANAGE_CMD =
      if Platform::os_type == Platform::WINDOWS
        default_cmd = 'VBoxManage.exe'
        default_path = 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe'
        if system("\"#{default_cmd}\" --version #{hide_cmd_output}")
          default_cmd
        elsif system("\"#{default_path}\" --version #{hide_cmd_output}")
          default_path
        else
          abort("Error: VBoxManage.exe not found, either add it to your PATH or install it at '#{default_path}'")
        end
      else
        default_cmd = 'vboxmanage'
        if system("\"#{default_cmd}\" --version #{hide_cmd_output}")
          default_cmd
        else
          abort("Error: vboxmanage not found, please install it and ensure it is in your PATH")
        end
      end
    private_constant :VBOX_MANAGE_CMD
  end
end
