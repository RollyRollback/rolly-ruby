require 'action_state'

class Action
  def initialize(retries: 0, steps: [], state: ActionState.new)
    @retries = retries
    @execution_steps = steps.clone
    @state = state
    @last_attempted_step = 0
  end

  def add(*steps)
    execution_steps.concat(steps)
  end

  def execute
    unless execute_steps
      return false if rollback

      raise RollbackFailedError, 'rollback failed'
    end

    state.result
  end

  def pop(num_of_steps = 1)
    return execution_steps.slice!(-1) if num_of_steps == 1

    execution_steps.slice!(-num_of_steps..-1)
  end

  private

  attr_reader :execution_steps, :retries, :state
  attr_accessor :last_attempted_step

  # XXX(sunny-b): uncomment this method when ready to incorporate retries
  # def successful?(step_action)
  #   max_retries = contains_retries?(step) ? step.retries : retries
  #   attempts ||= 0
  #   success = false
  #
  #   until success || attempts > max_retries
  #     success = step_action.call(state)
  #     attempt += 1
  #   end
  #
  #   success
  # rescue StandardError
  #   retry unless (attempts += 1) >= max_retries
  #   false
  # end

  def successful?(step_action)
    step_action.call(state)
  rescue StandardError
    false
  end

  def execute_steps
    execution_steps.each_with_index do |step, index|
      next if successful?(step.execute)

      self.last_attempted_step = index
      return false
    end

    true
  end

  def rollback
    self.last_attempted_step -= 1 unless rollback_on_failed_attempt?

    last_attempted_step.downto(0) do |step_idx|
      step = execution_steps[step_idx]

      return false unless successful?(step.rollback)
    end

    true
  end

  def contains_retries?(step)
    step.respond_to?(:retries) && step.retries
  end

  def rollback_on_failed_attempt?
    execution_steps[last_attempted_step].rollback_on_failed_attempt?
  end
end
