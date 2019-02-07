module VBoxManage
  def self.ensure_cmd_exists
    unless File.file?(VBOX_MANAGE_CMD)
      abort "ERROR: \"#{VBOX_MANAGE_CMD}\" is not found. Please install VBoxManage.exe to this location and try again."
    end
  end

  def self.has_provisioned(vm_name)
    system("\"#{VBOX_MANAGE_CMD}\" showvminfo #{vm_name} >nul 2>&1")
  end

  def self.mount_folders(vb, name_path_hash)
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/SharedFolders/MountPrefix", ""]
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/SharedFolders/MountDir", "/home/vagrant"]
    name_path_hash.each do |name, path|
      vb.customize ["sharedfolder", "add", :id, "--name", name, "--hostpath", abs_path(path), "--automount"]
      vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/#{name}", "1"]
    end
  end

  def self.configure_resolution(vm_name, display_info)
    system("\"#{VBOX_MANAGE_CMD}\" controlvm #{vm_name} setevideomodehint #{display_info[:display_width]} #{display_info[:display_height]} #{display_info[:display_color_depth]} >nul 2>&1")
  end

  private

  VBOX_MANAGE_CMD = 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe'
  private_constant :VBOX_MANAGE_CMD

  def self.abs_path(rel_path)
    File.expand_path(rel_path).gsub('/', '\\')
  end
  private_class_method :abs_path
end
