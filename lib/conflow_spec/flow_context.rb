# frozen_string_literal: true

module ConflowSpec
  # Defines context of the spec
  # - changes {http://www.rubydoc.info/gems/conflow/0.2.0/Conflow/Flow Conflow::Flow} class to queue jobs into special
  #   test queue
  # - defines worker which collects informations about jobs to be performed
  # @note In test flows jobs will not be performed - it only tests if the jobs were enqueued with proper parameters
  # @api private
  module FlowContext
    extend RSpec::SharedContext

    before { allow(described_class).to receive(:new).and_return(_conflow_spec_test_class.new) }

    # Subclass of a described class with overriden queueing logic
    # @see TestFlow
    def _conflow_spec_test_class
      @_conflow_spec_test_class ||= ConflowSpec::TestFlow.build(described_class, _conflow_spec_queue)
    end

    # Queue which collects queued jobs
    # @see TestFlow
    def _conflow_spec_queue
      @_conflow_spec_queue ||= Thread::Queue.new
    end
  end
end
