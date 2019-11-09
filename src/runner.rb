require_relative 'steps'

module Provision
  module Runner
    def self.run(stage, *args)
      step = stage
      pre_step = "pre_#{step.to_s}".to_sym
      post_step = "post_#{step.to_s}".to_sym

      add_step_if_exist(pre_step, *args)
      add_step_if_exist(step, *args)
      add_step_if_exist(post_step, *args)
    end

    private

    def self.add_step_if_exist(step, *args)
      if Steps::methods(false).include? step
        Steps::public_send(step, *args)
        puts "Added step '#{step.to_s}' to provisioner"
      end
    end
    private_class_method :add_step_if_exist
  end
end
