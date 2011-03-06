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
  
  # Raised when an ambiguous area name is given, e.g. Whitechapel (is it in London? Devon? Lancashire?)
  class DisambiguationError < StandardError
    
    # Array of possible locations (Strings)
    attr_reader :areas
    
    def initialize(areas)
      @areas = areas
    end

  end
  
  # Raised when an unknown location is searched for, e.g. Stok
  class UnknownLocationError < StandardError
    
    # String, a spelling suggestion, may be nil
    attr_reader :suggestion
    
    def initialize(suggestion)
      @suggestion = suggestion
    end
    
  end
  
end