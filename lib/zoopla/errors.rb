class Zoopla
  
  # Raised when Zoopla returns the HTTP status code 400
  class BadRequestError < StandardError; end
  
  # Raised when Zoopla returns the HTTP status code 401
  class UnauthorizedRequestError < StandardError; end
  
  # Raised when Zoopla returns the HTTP status code 403
  class ForbiddenError < StandardError; end
  
  # Raised when Zoopla returns the HTTP status code 404
  class NotFoundError < StandardError; end
  
  # Raised when Zoopla returns the HTTP status code 405
  class MethodNotAllowedError < StandardError; end
  
  # Raised when Zoopla returns the HTTP status code 500
  class InternalServerError < StandardError; end
  
  class DisambiguationError < StandardError
    
    attr_reader :areas
    
    def initialize(areas)
      @areas = areas
    end

  end
  
  class UnknownLocationError < StandardError
    
    attr_reader :suggestion
    
    def initialize(suggestion)
      @suggestion = suggestion
    end
    
  end
  
end