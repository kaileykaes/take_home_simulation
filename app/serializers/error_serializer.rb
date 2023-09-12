class ErrorSerializer
  def self.serialize_error(error, status)
    {
    error:
      {
        status: status, 
        message: error.message
      }
    }
  end
end