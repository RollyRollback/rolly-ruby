class Step
  attr_reader :retries, :execute, :rollback

  def initialize(execute:, rollback:, retries: 0, rollback_on_failed_attempt: false)
    @execute = execute
    @rollback = rollback
    @retries = retries
    @rollback_on_failed_attempt = rollback_on_failed_attempt
  end

  def rollback_on_failed_attempt?
    rollback_on_failed_attempt
  end

  private

  attr_reader :rollback_on_failed_attempt
end
