require 'step_without_rollback'

describe StepWithoutRollback do
  let(:execute) { ->(_) { true } }
  let(:state) { double(:action_state) }

  describe '#rollback' do
    before do
      @step = StepWithoutRollback.new(execute: execute)
    end

    it 'always returns a lambda that returns true' do
      expect(@step.rollback.call(state)).to be true
    end
  end
end
