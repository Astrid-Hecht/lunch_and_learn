class Error
  attr_reader :status,
              :msg

  def initialize(status, msg)
    @status = status
    @msg = msg
  end
end