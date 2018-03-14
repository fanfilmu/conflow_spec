# frozen_string_literal: true

module ConflowSpec
  module Matchers
    # Specifies that flow should at some point enqueue specific job.
    class RunJob
      include RSpec::Matchers

      attr_reader :job_class, :expected_params, :flow

      # @param job_class [Class] class of the worker expected to be run
      def initialize(job_class)
        @job_class = job_class
        @times = 1
      end

      # @param flow [Conflow::Flow] flow instance which should enqueue job
      # @return [Boolean] true if all requirements are fulfilled
      def matches?(flow)
        @flow = flow

        relevant_jobs.size == @times
      end

      # Specifies parameters that the job should be run with.
      # @param params [Hash] hash of job params
      # @example
      #   expect(flow).to run_job(MyService).with_params(id: 100)
      def with_params(params)
        @expected_params = params
        self
      end

      # Convinience method to specify job should be enqueued twice
      # @see times
      def twice
        @times = 2
        self
      end

      # Specifies how many times job should be run
      # @param num [Integer] number of times
      # @example
      #   expect(flow).to run_job(MyService).twice
      def times(num)
        @times = num
        self
      end

      # Description of the spec
      def description
        [
          "run job #{job_class}",
          expected_params && "with parameters #{expected_params}",
          times_text(@times)
        ].compact.join(" ")
      end

      # Error message when matcher returns true, but it was expected to return false
      def failure_message_when_negated
        [
          "Expected flow to not",
          description,
          "but it did"
        ].join(" ")
      end

      # Error message when matcher returns false, but it was expected to return true
      def failure_message
        [
          "Expected flow to",
          description,
          "but",
          if relevant_jobs.size.zero?
            run_with_different_params? ? "it was not run with those parameters" : "it was not run at all"
          elsif relevant_jobs != @times
            "it was run #{times_text(relevant_jobs.size)}"
          end
        ].join(" ")
      end

      private

      def relevant_jobs
        @relevant_jobs ||= runner.performed_jobs.select do |(type, params)|
          type == job_class && (!expected_params || params == expected_params)
        end
      end

      def run_with_different_params?
        expected_params && runner.performed_jobs.any? do |(type, params)|
          type == job_class && params != expected_params
        end
      end

      def runner
        @runner ||= ConflowSpec::Runner.new(flow).tap(&:run)
      end

      def times_text(num)
        case num
        when 1 then "once"
        when 2 then "twice"
        else "#{num} times"
        end
      end
    end
  end
end
