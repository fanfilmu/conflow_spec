# frozen_string_literal: true

module ConflowSpec
  # Defines context of the spec
  # - changes {http://www.rubydoc.info/gems/conflow/0.2.0/Conflow/Flow Conflow::Flow} class to queue jobs into special
  #   test queue
  # - defines worker which collects informations about jobs to be performed
  # @note In test flows jobs will not be performed - it only tests if the jobs were enqueued with proper parameters
  module FlowContext
    extend RSpec::SharedContext

    before { allow(described_class).to receive(:new).and_return(_conflow_spec_test_instance) }

    # Simple struct to hold mocked return values of the jobs
    JobProductStruct = Struct.new(:job_class, :params, :result) do
      alias_method :to, :result=
    end

    # Allows to define returned value by a job (which then can be user by hook attached to the job itself).
    # @param job_class [Class] Class of the job
    # @param params [Object] Value to be returned by job when processed
    # @example
    #   class MyFlow < Conflow::Flow
    #     def configure(id:)
    #       run UpdateJob, params: { id: id }, hook: :send_notifications
    #     end
    #
    #     def send_notifications(emails:)
    #       emails.each { |email| run NotificationJob, params: { email: email } }
    #     end
    #   end
    #
    #   RSpec.describe MyFlow do
    #     before { allow_job(UpdateJob, id: 110).to produce(emails: ["user1@example.com", "user2@example.com"]) }
    #     subject { described_class.create(id: 110) }
    #
    #     it { is_expected.to run_job(NotificationJob).with_params(email: "user1@example.com") }
    #     it { is_expected.to run_job(NotificationJob).with_params(email: "user2@example.com") }
    #   end
    #
    def allow_job(job_class, params = nil)
      JobProductStruct.new(job_class, params).tap do |struct|
        _conflow_spec_test_instance._conflow_spec_returns << struct
      end
    end

    # Defines value returned by given job
    # @see allow_job
    def produce(result)
      result
    end

    # Instance of the TestFlow
    # @see TestFlow
    # @api private
    def _conflow_spec_test_instance
      @_conflow_spec_test_instance ||= _conflow_spec_test_class.new
    end

    # Subclass of a described class with overriden queueing logic
    # @see TestFlow
    # @api private
    def _conflow_spec_test_class
      @_conflow_spec_test_class ||= ConflowSpec::TestFlow.build(described_class, _conflow_spec_queue)
    end

    # Queue which collects queued jobs
    # @see TestFlow
    # @api private
    def _conflow_spec_queue
      @_conflow_spec_queue ||= Thread::Queue.new
    end
  end
end
