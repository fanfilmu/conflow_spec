# frozen_string_literal: true

module ConflowSpec
  # Module which, when included, will override logic of queueing jobs.
  # @api private
  module TestFlow
    class << self
      # Creates new class which behaves like *flow_class* (class being tested), but with overriden logic
      # of queueing jobs.
      # @param flow_class [Class] Described class
      # @param queue [Thread::Queue] Queue to which jobs should be pushed
      # @return [Class] Class with changed queueing logic
      # @example
      #   flow = ConflowSpec::TestFlow.build(MyFlow, job_queue).new
      #   flow.is_a?(MyFlow) #=> true
      #   flow.name #=> MyFlow
      def build(flow_class, queue)
        Class.new(flow_class).tap do |test_class|
          test_class.prepend(self)
          test_class.name = flow_class.name
          test_class.queue = queue
        end
      end

      # Adds name and queue attributes on test class
      def prepended(base)
        base.singleton_class.instance_exec do
          attr_accessor :name, :queue
        end
      end
    end

    # Queues job pushing it to a Thread::Queue
    def queue(job)
      self.class.queue << job
    end
  end
end
