class RollbackFailedError < StandardError
  def to_s
    'failed to rollback step'
  end
end
