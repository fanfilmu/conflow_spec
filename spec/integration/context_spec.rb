# frozen_string_literal: true

TryJob = Class.new
UseForceJob = Class.new
PlayMarch = Class.new

SimpleFlow = Class.new(Conflow::Flow) do
  def configure(force: true)
    run TryJob, params: { elements: :stones } unless force
    run UseForceJob, after: TryJob, hook: :meditate
  end

  def meditate(result)
    run PlayMarch if result == :dark
  end
end

RSpec.describe SimpleFlow, conflow: true do
  subject { described_class.create(force: force) }

  context "when using dark side" do
    before { allow_job(UseForceJob).to produce(:dark) }

    context "when force is true" do
      let(:force) { true }

      it { is_expected.to_not run_job(TryJob).with_params(elements: :stones) }
      it { is_expected.to run_job(UseForceJob) }
      it { is_expected.to run_job(PlayMarch) }
    end

    context "when force is false" do
      let(:force) { false }

      it { is_expected.to run_job(TryJob) }
      it { is_expected.to run_job(UseForceJob) }
      it { is_expected.to run_job(PlayMarch) }
    end
  end

  context "when using light side" do
    before { allow_job(UseForceJob).to produce(:light) }

    context "when force is true" do
      let(:force) { true }

      it { is_expected.to_not run_job(TryJob).with_params(elements: :stones) }
      it { is_expected.to run_job(UseForceJob) }
      it { is_expected.to_not run_job(PlayMarch) }
    end

    context "when force is false" do
      let(:force) { false }

      it { is_expected.to run_job(TryJob) }
      it { is_expected.to run_job(UseForceJob) }
      it { is_expected.to_not run_job(PlayMarch) }
    end
  end
end
