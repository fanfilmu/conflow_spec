# frozen_string_literal: true

RSpec.describe ConflowSpec::Matchers do
  include ConflowSpec::Matchers

  shared_examples "successful matcher with negated error message" do |message|
    it { is_expected.to eq true }

    context do
      before { subject }
      it { expect(matcher.failure_message_when_negated).to eq message }
    end
  end

  shared_examples "failed matcher with error message" do |message|
    it { is_expected.to eq false }

    context do
      before { subject }
      it { expect(matcher.failure_message).to eq message }
    end
  end

  describe "#run_job" do
    let(:flow) { ConflowSpec::TestFlow.build(Conflow::Flow, Thread::Queue.new).new }

    before do
      flow.run(Proc,   params: { name: "a" })
      flow.run(Class,  params: { name: "b" })
      flow.run(Module, params: { name: "c" })
      flow.run(Class,  params: { name: "d" })
      flow.run(Proc,   params: { name: "a" })
    end

    subject { matcher.matches?(flow) }

    context "matcher without modifiers" do
      context "when job was not run" do
        let(:matcher) { run_job(StandardError) }

        it_behaves_like "failed matcher with error message", <<~TEXT.chop
          Expected flow to run job StandardError once but it was not run at all
        TEXT
      end

      context "when job was run once" do
        let(:matcher) { run_job(Module) }

        it_behaves_like "successful matcher with negated error message", <<~TEXT.chop
          Expected flow to not run job Module once but it did
        TEXT
      end

      context "when job was run twice" do
        let(:matcher) { run_job(Class) }

        it_behaves_like "failed matcher with error message", <<~TEXT.chop
          Expected flow to run job Class once but it was run twice
        TEXT
      end
    end

    context "with params modifier" do
      context "when job was not run" do
        let(:matcher) { run_job(StandardError).with_params(name: "a") }

        it_behaves_like "failed matcher with error message", <<~TEXT.chop
          Expected flow to run job StandardError with parameters {:name=>\"a\"} once but it was not run at all
        TEXT
      end

      context "when job was not run with proper parameters" do
        let(:matcher) { run_job(Module).with_params(name: "a") }

        it_behaves_like "failed matcher with error message", <<~TEXT.chop
          Expected flow to run job Module with parameters {:name=>\"a\"} once but it was not run with those parameters
        TEXT
      end

      context "when job was run once with proper parameters" do
        let(:matcher) { run_job(Class).with_params(name: "d") }

        it_behaves_like "successful matcher with negated error message", <<~TEXT.chop
          Expected flow to not run job Class with parameters {:name=>"d"} once but it did
        TEXT
      end

      context "when job was run twice with proper parameters" do
        let(:matcher) { run_job(Proc).with_params(name: "a") }

        it_behaves_like "failed matcher with error message", <<~TEXT.chop
          Expected flow to run job Proc with parameters {:name=>"a"} once but it was run twice
        TEXT
      end
    end

    context "with times modifier" do
      context "when job was not run" do
        let(:matcher) { run_job(StandardError).twice }

        it_behaves_like "failed matcher with error message", <<~TEXT.chop
          Expected flow to run job StandardError twice but it was not run at all
        TEXT
      end

      context "when job was wrong number of times" do
        let(:matcher) { run_job(Class).times(3) }

        it_behaves_like "failed matcher with error message", <<~TEXT.chop
          Expected flow to run job Class 3 times but it was run twice
        TEXT
      end
    end

    context "with complex modifiers" do
      let(:matcher) { run_job(Proc).with_params(name: "a").twice }

      it_behaves_like "successful matcher with negated error message", <<~TEXT.chop
        Expected flow to not run job Proc with parameters {:name=>"a"} twice but it did
      TEXT
    end
  end
end
