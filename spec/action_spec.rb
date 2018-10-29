require 'action'
require 'action_state'

describe Action do
  let(:retries) { 0 }
  let(:state) { ActionState.new }
  let(:steps) { [] }
  let(:execute) { true }
  let(:fallback) { true }
  let(:rollback_on_failure) { false }

  let(:step) do
    double(
      :action_step,
      execute: ->(_) { execute },
      rollback: ->(_) { fallback },
      retries: retries,
      rollback_on_failed_attempt?: rollback_on_failure
    )
  end

  before do
    @action = Action.new(steps: steps, state: state, retries: retries)
  end

  context 'default parameters' do
    before do
      @action = Action.new
    end

    it 'initializes with empty array of steps' do
      expect(@action.send(:execution_steps)).to match_array([])
    end

    it 'initializes with 0 retries' do
      expect(@action.send(:retries)).to eq(0)
    end

    it 'initializes state as empty ActionState' do
      expect(@action.send(:state)).to be_kind_of(ActionState)
    end
  end

  describe '#add' do
    context 'single step' do
      before do
        @action.add(step)
      end

      it 'adds a step to the execution_steps' do
        expect(@action.send(:execution_steps).length).to eq(1)
        expect(@action.send(:execution_steps).first).to eq(step)
      end
    end

    context 'multiple steps' do
      before do
        more_steps = [step, step]
        @action.add(*more_steps)
      end

      it 'adds multiple steps to the execution_steps' do
        expect(@action.send(:execution_steps).length).to eq(2)
      end
    end
  end

  describe '#pop' do
    before do
      more_steps = [step, step]
      @action.add(*more_steps)
    end

    context 'single pop' do
      it 'removes one step' do
        expect(@action.send(:execution_steps).length).to eq(2)
        @action.pop
        expect(@action.send(:execution_steps).length).to eq(1)
      end

      it 'removes most recent step' do
        last_step = @action.send(:execution_steps).last
        expect(@action.pop).to eq(last_step)
      end
    end

    context 'multiple pops' do
      it 'removes multiple steps' do
        expect(@action.send(:execution_steps).length).to eq(2)
        @action.pop(2)
        expect(@action.send(:execution_steps).length).to eq(0)
      end
    end
  end

  describe '#execute' do
    context 'single successful step without result' do
      before do
        @action.add(step)
      end

      it 'returns true' do
        expect(@action.execute).to be true
      end

      it 'calls execute on the step' do
        expect(step).to receive(:execute).once
        @action.execute
      end
    end

    context 'single failure step without rollback' do
      let(:execute) { false }

      before do
        @action.add(step)
      end

      it 'returns false' do
        expect(@action.execute).to be false
      end

      it 'does not call rollback on the step' do
        expect(step).not_to receive(:rollback)
        @action.execute
      end

      it 'calls rollback_on_failed_attempt? on the step' do
        expect(step).to receive(:rollback_on_failed_attempt?).and_return(false).once
        @action.execute
      end
    end

    context 'single failure step with rollback' do
      let(:execute) { false }
      let(:rollback_on_failure) { true }

      before do
        @action.add(step)
      end

      it 'returns false' do
        expect(@action.execute).to be false
      end

      it 'calls rollback on the step' do
        expect(step).to receive(:rollback).once
        @action.execute
      end

      it 'calls rollback_on_failed_attempt? on the step' do
        expect(step).to receive(:rollback_on_failed_attempt?).and_return(true).once
        @action.execute
      end
    end
  end
end
