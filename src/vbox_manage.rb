module VBoxManage
  def self.ensure_cmd_exists
    unless File.file?(VBOX_MANAGE_CMD)
      abort "ERROR: \"#{VBOX_MANAGE_CMD}\" is not found. Please install VBoxManage.exe to this location and try again."
    end
  end

  def self.has_provisioned(machine)
    system("\"#{VBOX_MANAGE_CMD}\" showvminfo #{machine} >nul 2>&1")
  end

  def self.mount_folders(vb, name_path_hash)
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/SharedFolders/MountPrefix", ""]
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/SharedFolders/MountDir", "/home/vagrant"]
    name_path_hash.each do |name, path|
      vb.customize ["sharedfolder", "add", :id, "--name", name, "--hostpath", abs_path(path), "--automount"]
      vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/#{name}", "1"]
    end
  end

  def self.set_resolution(machine)
    description = `wmic path Win32_VideoController get VideoModeDescription`
    width, height, num_colors = description.match(/(\d+) x (\d+) x (\d+)/).captures
    color_depth = Math.log2(num_colors.to_i).to_i
    system("\"#{VBOX_MANAGE_CMD}\" controlvm #{machine} setevideomodehint #{width} #{height} #{color_depth} >nul 2>&1")
  end

  private

  VBOX_MANAGE_CMD = 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe'
  private_constant :VBOX_MANAGE_CMD

  def self.abs_path(rel_path)
    File.expand_path(rel_path).gsub('/', '\\')
  end
  private_class_method :abs_path
end
