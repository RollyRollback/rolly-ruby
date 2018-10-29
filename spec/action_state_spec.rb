require 'action_state'

describe ActionState do
  before { @state = ActionState.new }

  describe '#set' do
    before { @state.set(:test, 'test') }

    it 'sets a key value pair' do
      expect(@state.send(:state)[:test]).to eq('test')
    end
  end

  describe '#get' do
    before { @state.set(:test, 'test') }

    it 'retrieves the value from a key' do
      expect(@state.get(:test)).to eq('test')
    end
  end
end
