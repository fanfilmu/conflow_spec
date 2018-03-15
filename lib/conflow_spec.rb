# frozen_string_literal: true

require "conflow_spec/version"
require "conflow"
require "rspec"

require "conflow_spec/test_flow"
require "conflow_spec/flow_context"
require "conflow_spec/runner"
require "conflow_spec/matchers/run_job"
require "conflow_spec/matchers"

# ConflowSpec defines sets of contexts and matchers to easily and responsibly test your Conflow flows.
module ConflowSpec
end

RSpec.configure do |config|
  config.include ConflowSpec::FlowContext, conflow: true
  config.include ConflowSpec::Matchers, conflow: true
end
