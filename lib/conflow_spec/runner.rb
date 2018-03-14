# frozen_string_literal: true

module ConflowSpec
  # Runs the flow and collects informations about it
  class Runner
    attr_reader :flow, :performed_jobs

    # @param flow [Conflow::Flow] instance of the flow
    def initialize(flow)
      @flow = flow
      @queue = queue
      @performed_jobs = []
    end

    # Performs all jobs in the flow, saving results in {performed_jobs}
    def run
      finish(queue.pop) until queue.empty?
    end

    private

    def finish(job)
      performed_jobs << [job.worker_type, job.params.to_h]
      flow.finish(job)
    end

    def queue
      flow.class.queue
    end
  end
end
