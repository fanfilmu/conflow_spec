# frozen_string_literal: true

RSpec.describe ConflowSpec::TestFlow do
  let(:flow_class) { Conflow::Flow }
  let(:queue)      { Thread::Queue.new }

  let(:test_class) { described_class.build(flow_class, queue) }
  let(:test_flow)  { test_class.new }

  describe ".build" do
    subject { test_class }

    it { is_expected.to have_attributes(name: "Conflow::Flow", queue: queue) }
    it { is_expected.to be < Conflow::Flow }
  end

  context "when a job is added" do
    let!(:job) { test_flow.run Proc }

    it "adds job to queue" do
      expect(queue.pop).to eq job
    end
  end
end
