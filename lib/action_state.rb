class ActionState
  attr_accessor :result

  def initialize(state = {})
    @result = true
    @state = state
  end

  def set(key, val)
    state[key] = val
  end

  def get(key)
    state[key]
  end

  private

  attr_reader :state
end
