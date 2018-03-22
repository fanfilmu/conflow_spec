# frozen_string_literal: true

module ConflowSpec
  # Runs the flow and collects informations about it
  class Runner
    include Conflow::Worker

    attr_reader :flow, :performed_jobs

    # @param flow [Conflow::Flow] instance of the flow
    def initialize(flow)
      @flow = flow
      @queue = queue
      @performed_jobs = []
    end

    # Performs all jobs in the flow, saving results in {performed_jobs}
    def run
      until queue.empty?
        job = queue.pop

        perform(flow.id, job.id) do |worker_type, params|
          performed_jobs << [worker_type, params.to_h]
          fetch_result(job)
        end
      end
    end

    private

    def queue
      flow.class.queue
    end

    def fetch_result(job)
      matching_by_class = flow._conflow_spec_returns.select { |struct| struct.job_class == job.worker_type }
      matching_by_params = matching_by_class.select { |struct| struct.params == job.params.to_h }

      (matching_by_params.first || matching_by_class.first)&.result
    end
  end
end
