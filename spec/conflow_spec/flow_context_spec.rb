# frozen_string_literal: true

RSpec.describe ConflowSpec::FlowContext do
  let(:described_class) { Class.new(Conflow::Flow) }

  include ConflowSpec::FlowContext

  let(:instance) { described_class.new }

  describe "#_conflow_spec_test_class" do
    subject { _conflow_spec_test_class }

    it { is_expected.to be < described_class }
  end

  describe "#_conflow_spec_queue" do
    subject { _conflow_spec_queue }

    it { is_expected.to be_a_kind_of(Thread::Queue) }
    it { is_expected.to eq _conflow_spec_test_class.queue }
  end

  describe "instance of described class" do
    subject { instance }

    it { is_expected.to be_a_kind_of(_conflow_spec_test_class) }
  end
end
