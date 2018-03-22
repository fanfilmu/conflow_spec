# frozen_string_literal: true

TryJob = Class.new
UseForceJob = Class.new
PlayMarch = Class.new

SimpleFlow = Class.new(Conflow::Flow) do
  def configure(force: true)
    run TryJob, params: { elements: :stones } unless force
    job = run UseForceJob, after: TryJob
    run PlayMarch, params: { type: job.outcome[:type] }
  end
end

RSpec.describe SimpleFlow, conflow: true do
  subject { described_class.create(force: force) }

  context "when using dark side" do
    before { allow_job(UseForceJob).to produce(type: :dark) }

    context "when force is true" do
      let(:force) { true }

      it { is_expected.to_not run_job(TryJob).with_params(elements: :stones) }
      it { is_expected.to run_job(UseForceJob) }
      it { is_expected.to run_job(PlayMarch).with_params(type: "dark") }
    end

    context "when force is false" do
      let(:force) { false }

      it { is_expected.to run_job(TryJob) }
      it { is_expected.to run_job(UseForceJob) }
      it { is_expected.to run_job(PlayMarch).with_params(type: "dark") }
    end
  end

  context "when using light side" do
    before { allow_job(UseForceJob).to produce(type: :light) }

    context "when force is true" do
      let(:force) { true }

      it { is_expected.to_not run_job(TryJob).with_params(elements: :stones) }
      it { is_expected.to run_job(UseForceJob) }
      it { is_expected.to run_job(PlayMarch).with_params(type: "light") }
    end

    context "when force is false" do
      let(:force) { false }

      it { is_expected.to run_job(TryJob) }
      it { is_expected.to run_job(UseForceJob) }
      it { is_expected.to run_job(PlayMarch).with_params(type: "light") }
    end
  end
end
