require 'step'

class StepWithoutRollback < Step
  def initialize(execute:, retries: 0, rollback_on_failed_attempt: false)
    super(
      execute: execute,
      rollback: ->(_) { true },
      retries: retries,
      rollback_on_failed_attempt: rollback_on_failed_attempt
    )
  end
end
