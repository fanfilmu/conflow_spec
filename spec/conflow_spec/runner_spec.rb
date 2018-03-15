# frozen_string_literal: true

RSpec.describe ConflowSpec::Runner do
  let(:flow_class) { ConflowSpec::TestFlow.build(Conflow::Flow, queue) }
  let(:queue)      { Thread::Queue.new }
  let(:flow)       { flow_class.new }
  let(:runner)     { described_class.new(flow) }

  before do
    job1 = flow.run Proc, params: { name: "first" }
    job2 = flow.run Proc, params: { name: "second" }
    flow.run Proc, params: { name: "goal" }, after: [job1, job2]
    flow.run Proc, params: { name: "other" }
  end

  describe "#run!" do
    subject { runner.run }

    let(:expected_order) do
      [
        [Proc, name: "first"],
        [Proc, name: "second"],
        [Proc, name: "other"],
        [Proc, name: "goal"]
      ]
    end

    it { expect { subject }.to change { runner.performed_jobs }.to eq expected_order }

    context "when flow has some return values defined" do
      before do
        flow._conflow_spec_returns << double(job_class: Proc, params: { name: "with hook" }, result: :ok)
        flow.run Proc, params: { name: "with hook" }, hook: :verify_result
      end

      it "runs hook with proper result" do
        expect(flow).to receive(:verify_result).with(:ok)
        subject
      end
    end
  end
end
