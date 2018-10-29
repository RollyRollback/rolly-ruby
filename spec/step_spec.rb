require 'step'

describe Step do
  let(:execute) { ->(_) { 'execute' } }
  let(:rollback) { ->(_) { 'rollback' } }
  let(:retries) { 5 }
  let(:rollback_on_failed_attempt) { true }

  before do
    @step = Step.new(
      execute: execute,
      rollback: rollback,
      retries: retries,
      rollback_on_failed_attempt: rollback_on_failed_attempt
    )
  end

  describe '#execute' do
    it 'returns the proc/lambda passed in' do
      expect(@step.execute).to eq(execute)
    end

    it 'returns an object that responds to "call"' do
      expect(@step.execute.respond_to?(:call)).to be true
    end
  end

  describe '#rollback' do
    it 'returns the proc/lambda passed in' do
      expect(@step.rollback).to eq(rollback)
    end

    it 'returns an object that responds to "call"' do
      expect(@step.rollback.respond_to?(:call)).to be true
    end
  end

  describe '#retries' do
    it 'returns the number of retries it was initiated with' do
      expect(@step.retries).to eq(retries)
    end
  end

  describe '#rollback_on_failed_attempt' do
    it 'returns the boolean with which it was initiated' do
      expect(@step.rollback_on_failed_attempt?).to eq(rollback_on_failed_attempt)
    end
  end
end
