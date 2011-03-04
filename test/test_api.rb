require 'helper'

class TestAPI < Test::Unit::TestCase
  
  def setup
    @rentals = Zoopla.new('my_api_key').rentals
  end
  
  def test_no_results_returned
    number_of_results, reply = @rentals.send(:preprocess, api_reply('empty'))
    assert_equal 0, number_of_results
    assert_equal [], reply
  end
    
  def test_bad_request
    Curl::Easy.any_instance.stubs(:perform)
    Curl::Easy.any_instance.stubs(:response_code).returns(400)
    assert_raises Zoopla::BadRequestError do
      @rentals.each{}
    end
  end
  
  def test_unauthorised_request
    Curl::Easy.any_instance.stubs(:perform)
    Curl::Easy.any_instance.stubs(:response_code).returns(401)
    assert_raises Zoopla::UnauthorizedRequestError do
      @rentals.each{}
    end
  end
  
  def test_wrong_api_key
    Curl::Easy.any_instance.stubs(:perform)
    Curl::Easy.any_instance.stubs(:response_code).returns(403)
    assert_raises Zoopla::ForbiddenError do
      @rentals.each{}
    end
  end
  
  def test_not_found
    Curl::Easy.any_instance.stubs(:perform)
    Curl::Easy.any_instance.stubs(:response_code).returns(404)
    assert_raises Zoopla::NotFoundError do
      @rentals.each{}
    end
  end
  
  def test_method_not_allowed
    Curl::Easy.any_instance.stubs(:perform)
    Curl::Easy.any_instance.stubs(:response_code).returns(405)
    assert_raises Zoopla::MethodNotAllowedError do
      @rentals.each{}
    end
  end
  
  def test_internal_server_error
    Curl::Easy.any_instance.stubs(:perform)
    Curl::Easy.any_instance.stubs(:response_code).returns(500)
    assert_raises Zoopla::InternalServerError do
      @rentals.each{}
    end
  end
  
end