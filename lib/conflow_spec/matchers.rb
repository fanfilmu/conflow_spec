# frozen_string_literal: true

module ConflowSpec
  # Collection of matchers used to spec flows
  module Matchers
    # Run job matchers checks if job of giben worker class is run in the flow.
    # @example Verifying simple flow
    #   class MyFlow < Conflow::Flow
    #     def configure(run_other: true)
    #       run RegularJob
    #       run OtherJob if run_other
    #     end
    #   end
    #
    #   RSpec.describe MyFlow do
    #     subject { described_class.create(run_other: false) }
    #
    #     it { is_expected.to run_job(RegularJob) }
    #     it { is_expected.to_not run_job(OtherJob) }
    #   end
    #
    # @example Specifying parameters
    #   class MyFlow < Conflow::Flow
    #     def configure(id:)
    #       run UpdateJob, params: { id: id }
    #     end
    #   end
    #
    #   RSpec.describe MyFlow do
    #     subject { described_class.create(id: 300) }
    #
    #     it { is_expected.to run_job(UpdateJob).with_params(id: 300) }
    #     it { is_expected.to_not run_job(UpdateJob).with_params(id: 301) }
    #   end
    #
    # @example Specifying amounts
    #   class MyFlow < Conflow::Flow
    #     def configure(ids:)
    #       ids.each { |id| run UpdateJob, params: { id: id } }
    #     end
    #   end
    #
    #   RSpec.describe MyFlow do
    #     subject { described_class.create(ids: [300, 301]) }
    #
    #     it { is_expected.to run_job(UpdateJob).twice } # or .times(2)
    #     it { is_expected.to run_job(UpdateJob).with_params(id: 300) }
    #     it { is_expected.to run_job(UpdateJob).with_params(id: 301) }
    #   end
    # @param job_class [Class] Worker class that is (not) expected to run
    # @return [RunJob}] RSpec matcher
    def run_job(job_class)
      RunJob.new(job_class)
    end
  end
end
