require_relative 'steps'

module Provision
  module Runner
    STEPS = [:prepare, :install, :configure, :cleanup].flat_map do |step|
      ["pre_#{step.to_s}".to_sym, step, "post_#{step.to_s}".to_sym]
    end

    STEPS.each do |step|
      unless Steps::methods(false).include?(step)
        Steps::define_singleton_method(step, &proc{ |a, b| })
      end
    end

    def self.run(*args)
      STEPS.each do |step|
        Steps::public_send(step, *args)
      end
    end

    def self.load_extra_steps(extra_steps)
      extra_steps.each do |mod, script|
        require(File.expand_path(script))
        Steps::singleton_class::prepend Object.const_get("Provision::#{mod}")
      end
    end
  end
end
