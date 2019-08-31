require 'cgi'
require 'io/console'
require 'yaml'
require 'digest/sha1'

module VMConfig
  def self.initialize_vm_configuration
    trap('INT') do
      abort "\nAborted VM configuration."
    end

    config = File.file?(CONFIG_FILE) ? get_config_from_file : nil

    if config.nil?
      puts "(Re)configuring your VM. Answer the following questions. Press Ctrl+C anytime to quit."
      config = get_config_from_user
      File.write(CONFIG_FILE, config.to_yaml)
      puts "Saved configuration settings to #{CONFIG_FILE}"
    end

    config.validate
    config
  end

  def self.print_configs
    unless File.file?(CONFIG_FILE)
      abort "Error: config file #{CONFIG_FILE} not found. Try running again to re-create it."
    end
    puts "Using the following VM configs:\n#{load_config_file}"
  end

  private

  CONFIG_FILE = '.vm-config.yaml'
  private_constant :CONFIG_FILE

  def self.ask(question, default = '', default_text = default)
    print "#{question} #{default_text.empty? ? '' : "(default: #{default_text}): "}"
    $stdin.flush
    $stdout.flush
    response = $stdin.gets.chomp
    response.empty? ? default : response
  end
  private_class_method :ask

  def self.yesno(question, default = '', default_text = default)
    response = ask(question, default, default_text)
    response.start_with?('y')
  end
  private_class_method :yesno

  def self.get_config_from_user
    vm_name = ask('What is the name of this VM?', 'devbox')
    base_memory = ask('What is the base machine memory in MB?', '8192').to_i
    disk_space = ask('What is the virtual hard drive size in GB?', '50').to_i
    processors = ask('What is the number of processors?', '4').to_i
    video_memory = ask('What is the video memory in MB?', '128').to_i
    monitor_count = ask('What is the number of monitors?', '1').to_i
    timezone = ask('What is the timezone? (eg. America/Toronto)', 'UTC')
    restart = yesno('Restart after provisioning? (you can change this later)', 'yes')

    Config.new(vm_name, base_memory, disk_space, processors, video_memory, monitor_count, timezone, restart)
  end
  private_class_method :get_config_from_user

  def self.get_config_from_file
    saved_configs = load_config_file
    if saved_configs.serial_version_id != Config.serial_version_id
      puts "Warning: your #{CONFIG_FILE} file is outdated."
      return nil
    end
    saved_configs
  end
  private_class_method :get_config_from_file

  def self.load_config_file
    begin
      return YAML.load_file(CONFIG_FILE)
    rescue => error
      puts error.backtrace
      abort "Error: unable to load VM configuration settings from #{CONFIG_FILE}. Try deleting the file and run again."
    end
  end
  private_class_method :load_config_file

  class Config
    attr_reader :serial_version_id, :vm_name, :base_memory, :disk_space, :processors, :video_memory, :monitor_count,
                :timezone, :restart, :extra_scripts, :extra_mounts

    def initialize(vm_name, base_memory, disk_space, processors, video_memory, monitor_count, timezone, restart)
      @serial_version_id = nil
      @vm_name = vm_name
      @base_memory = base_memory
      @disk_space = disk_space
      @processors = processors
      @video_memory = video_memory
      @monitor_count = monitor_count
      @timezone = timezone
      @restart = restart
      @extra_scripts = []
      @extra_mounts = {}

      self.initialize_serial_version_id
    end

    def own_vars
      self.instance_variables.map(&:to_s)
    end

    def initialize_serial_version_id
      @serial_version_id = Digest::SHA1.hexdigest(own_vars.sort.join('|'))
    end

    def to_hash
      self.own_vars.select { |f| f != '@serial_version_id' }.reduce({}) do |hash, f|
        hash[f.delete('@')] = self.instance_variable_get f
        hash
      end
    end

    def to_s
      fields = own_vars.dup
      body = fields.select { |f| f != '@serial_version_id' }
               .map { |f| "    #{f.delete('@')}: #{self.instance_variable_get f}" }
               .join("\n")
      "{\n#{body}\n}"
    end

    def validate
      failed_msg = 'Error: vm-config file validation failed'

      extra_scripts.each do |path|
        unless File.file?(path)
          abort("#{failed_msg}. Extra provision script not found at path '#{path}'")
        end
      end

      extra_mounts.each do |name, path|
        if name.nil? || name.empty?
          abort("#{failed_msg}. Extra mount cannot be created, mount name cannot be empty for path '#{path}'")
        end
        unless File.directory?(path)
          abort("#{failed_msg}. Extra mount cannot be created, host directory does not exist at '#{path}'")
        end
      end
    end

    def self.serial_version_id
      self.new(*Array.new(self.instance_method(:initialize).arity, '')).serial_version_id
    end
  end
end
