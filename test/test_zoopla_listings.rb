require 'helper'

class TestZooplaListings < Test::Unit::TestCase
  
  def setup
    @rentals = Zoopla::Listings::Rentals.new('abcdef123')
    @sales   = Zoopla::Listings::Sales.new('abcdef123')
  end
  
  def test_reset_for_sales
    @sales.include_sold
    assert_equal({:listing_status=>"sale", :include_sold => '1'}, @sales.instance_variable_get('@request'))
    @sales.reset!
    assert_equal({:listing_status=>"sale"}, @sales.instance_variable_get('@request'))
  end
  
  def test_reset_for_rentals
    @rentals.include_rented
    assert_equal({:listing_status=>"rent", :include_rented => '1'}, @rentals.instance_variable_get('@request'))
    @rentals.reset!
    assert_equal({:listing_status=>"rent"}, @rentals.instance_variable_get('@request'))
  end
  
  def test_in
    listing_parameter_test(:in, {:postcode => 'E1W 3TJ'}, {:postcode => 'E1W 3TJ'})
  end
  
  def test_within
    listing_parameter_test(:within, 2, {:radius => 2})    
  end
  
  def test_radius
    listing_parameter_test(:radius, 2, {:radius => 2})
  end
  
  def test_order_by
    listing_parameter_test(:order_by, :age, {:order_by => 'age'})
    listing_parameter_test(:order_by, :price, {:order_by => 'price'})
    assert_raise RuntimeError do
      listing_parameter_test(:order_by, :blah, {}) 
    end
    assert_raise RuntimeError do
      listing_parameter_test(:order_by, nil, {}) 
    end
  end
  
  def test_ordering
    listing_parameter_test(:ordering, :ascending, {:ordering => 'ascending'})
    listing_parameter_test(:ordering, :descending, {:ordering => 'descending'})
    assert_raise RuntimeError do
      listing_parameter_test(:ordering, :blah, {}) 
    end    
    assert_raise RuntimeError do
      listing_parameter_test(:ordering, nil, {}) 
    end    
  end
  
  def test_include_sold
    @sales.include_sold
    expected = {:listing_status=>"sale", :include_sold => '1'}
    assert_equal expected, @sales.instance_variable_get('@request')    
  end
  
  def test_include_rented
    @rentals.include_rented
    expected = {:listing_status=>"rent", :include_rented => '1'}
    assert_equal expected, @rentals.instance_variable_get('@request')        
  end
  
  def test_minimum_price
    listing_parameter_test(:minimum_price, 300, {:minimum_price => 300})
    assert_raise RuntimeError do
      listing_parameter_test(:minimum_price, nil, {}) 
    end    
    assert_raise RuntimeError do
      listing_parameter_test(:minimum_price, -200, {}) 
    end        
  end
  
  def test_maximum_price
    listing_parameter_test(:maximum_price, 500, {:maximum_price => 500})
    assert_raise RuntimeError do
      listing_parameter_test(:maximum_price, nil, {}) 
    end    
    assert_raise RuntimeError do
      listing_parameter_test(:maximum_price, -200, {}) 
    end        
  end
  
  def test_price
    listing_parameter_test(:for, 200..500, {:minimum_price => 200, :maximum_price => 500})
    listing_parameter_test(:price, 200..500, {:minimum_price => 200, :maximum_price => 500})
    listing_parameter_test(:price, 200..200, {:minimum_price => 200, :maximum_price => 200})
    listing_parameter_test(:price, 200, {:minimum_price => 200, :maximum_price => 200})
    assert_raise RuntimeError do
      listing_parameter_test(:price, -200, {}) 
    end            
    assert_raise RuntimeError do
      listing_parameter_test(:price, 500..200, {}) 
    end            
    assert_raise RuntimeError do
      listing_parameter_test(:price, nil, {}) 
    end            
  end  
  
  def test_minimum_beds
    listing_parameter_test(:minimum_beds, 3, {:minimum_beds => 3})
    assert_raise RuntimeError do
      listing_parameter_test(:minimum_beds, nil, {}) 
    end    
    assert_raise RuntimeError do
      listing_parameter_test(:minimum_beds, -2, {}) 
    end        
  end
  
  def test_maximum_beds
    listing_parameter_test(:maximum_beds, 5, {:maximum_beds => 5})
    assert_raise RuntimeError do
      listing_parameter_test(:maximum_beds, nil, {}) 
    end    
    assert_raise RuntimeError do
      listing_parameter_test(:maximum_beds, -2, {}) 
    end        
  end
  
  def test_beds
    listing_parameter_test(:beds, 2..5, {:minimum_beds => 2, :maximum_beds => 5})
    listing_parameter_test(:beds, 2..2, {:minimum_beds => 2, :maximum_beds => 2})
    listing_parameter_test(:beds, 2, {:minimum_beds => 2, :maximum_beds => 2})
    assert_raise RuntimeError do
      listing_parameter_test(:beds, -2, {}) 
    end            
    assert_raise RuntimeError do
      listing_parameter_test(:beds, 5..2, {}) 
    end            
    assert_raise RuntimeError do
      listing_parameter_test(:beds, nil, {}) 
    end            
  end  
  
  def test_furnished
    listing_parameter_test(:furnished, 'furnished', {:furnished => 'furnished'})
    listing_parameter_test(:furnished, 'unfurnished', {:furnished => 'unfurnished'})
    listing_parameter_test(:furnished, 'part-furnished', {:furnished => 'part-furnished'})
    assert_raise RuntimeError do
      listing_parameter_test(:furnished, 'semi-furnished', {})
    end
    assert_raise RuntimeError do
      listing_parameter_test(:furnished, nil, {})
    end
  end
  
  def test_property_type
    listing_parameter_test(:property_type, 'houses', {:property_type => 'houses'})
    listing_parameter_test(:property_type, 'flats', {:property_type => 'flats'})
    assert_raise RuntimeError do
      listing_parameter_test(:property_type, nil, {})
    end    
    assert_raise RuntimeError do
      listing_parameter_test(:property_type, 'igloos', {})
    end    
  end
  
  def test_houses
    @sales.houses
    expected = {:listing_status=>"sale", :property_type => 'houses'}
    assert_equal expected, @sales.instance_variable_get('@request')    
  end
  
  def test_flats
    @sales.flats
    expected = {:listing_status=>"sale", :property_type => 'flats'}
    assert_equal expected, @sales.instance_variable_get('@request')    
  end
  
  def test_keywords
    listing_parameter_test(:keywords, 'very cheap centrally located spacious modern duplex', {:keywords => 'very cheap centrally located spacious modern duplex'})
  end
  
  def test_listing_id
    listing_parameter_test(:listing_id, 7, {:listing_id => [7]})
    listing_parameter_test(:listing_id, 11, {:listing_id => [7, 11]})
    listing_parameter_test(:listing_id, 13, {:listing_id => [7, 11, 13]})
  end
  
  def test_forming_the_request_by_chaining
    @rentals.flats.in({:postcode => 'E1W 3TJ'}).within(2).price(200..400).beds(1..2).furnished('furnished').include_rented.order_by(:price).ordering(:descending)
    expected = { :listing_status=>"rent",
                 :property_type=>"flats",
                 :postcode=>"E1W 3TJ",
                 :radius=>2,
                 :minimum_price=>200,
                 :maximum_price=>400,
                 :minimum_beds=>1,
                 :maximum_beds=>2,
                 :furnished=>"furnished",
                 :include_rented=>"1",
                 :order_by=>"price",
                 :ordering=>"descending"}
    assert_equal expected, @rentals.instance_variable_get('@request')
  end
  
  def test_only_correct_listing_types_requested_for_sales
    @sales.in({:postcode => 'E1W 3TJ'})
    expected = {:listing_status=>"sale", :postcode => 'E1W 3TJ'}
    assert_equal expected, @sales.instance_variable_get('@request')    
  end
  
  def test_only_correct_listing_types_requested_for_rentals
    @rentals.in({:postcode => 'E1W 3TJ'})
    expected = {:listing_status=>"rent", :postcode => 'E1W 3TJ'}
    assert_equal expected, @rentals.instance_variable_get('@request')    
  end
  
  def test_requesting_multiple_results_pages_transparently
    mock = mock();
    mock.expects(:process_listing).times(12);
    page1 = @rentals.send :preprocess, JSON.parse(api_reply('big_request_page1'))
    page2 = @rentals.send :preprocess, JSON.parse(api_reply('big_request_page2'))
    @rentals.stubs(:fetch_data).returns(page1, page2)
    @rentals.in({:postcode => 'E1W 3TJ'}).within(0.1).price(300..400).each {|listing|
      mock.process_listing
    }    
  end
  
  def test_deep_parsing_the_reply
    _, reply = @rentals.send(:preprocess, JSON.parse(api_reply('postcode')))
    listing = reply.first
    assert_equal 11695072, listing.listing_id
    assert_equal 'rent', listing.listing_status    
    assert_equal 275, listing.price
    assert_equal 'Atkinson Mcleod', listing.agent_name
    assert_equal '135 Leman Street, Aldgate', listing.agent_address
    assert_equal 'http://static.zoopla.co.uk/zoopla_static_agent_logo_(26302).gif', listing.agent_logo
    assert_match(/^Charming one double bedroom apartment .+Our Ref: rpl\/iupload\/CTL070029$/m, listing.description)
    assert_equal 'http://www.zoopla.co.uk/to-rent/details/11695072', listing.details_url
    assert_equal 'Prospect Place, Wapping Wall, Wapping, London E1W', listing.displayable_address
    assert_equal 'http://content.zoopla.co.uk/18d7d607146d3f0ea8cd46c48b5984084613a8ce.jpg', listing.floor_plan.first
    assert_equal 'Picture No.05', listing.image_caption
    assert_equal 'http://images.zoopla.co.uk/f03d30a35c97bf20825af1db8f9e52e1c936dd42_354_255.jpg', listing.image_url
    assert_equal 51.50639, listing.latitude
    assert_equal(-0.054738, listing.longitude)
    assert_equal 0, listing.num_bathrooms
    assert_equal 1, listing.num_bedrooms
    assert_equal 0, listing.num_floors
    assert_equal 0, listing.num_recepts
    assert_equal 'E1W', listing.outcode
    assert_equal 'London', listing.post_town
    assert_equal 265, listing.price_change.first.price
    assert_equal Date.parse('2010-07-23 19:12:46'), listing.price_change.first.date
    assert_equal 275, listing.price_change.last.price
    assert_equal Date.parse('2011-01-06 19:00:45'), listing.price_change.last.date
    assert_equal 'Flat', listing.property_type
    assert_equal 'Wapping Wall Wapping London', listing.street_name
    assert_equal 'http://images.zoopla.co.uk/f03d30a35c97bf20825af1db8f9e52e1c936dd42_80_60.jpg', listing.thumbnail_url
  end
  
  private
  
  def listing_parameter_test(param, value, result)
    @rentals.send(param, value)
    expected = {:listing_status=>"rent"}.merge! result
    assert_equal expected, @rentals.instance_variable_get('@request')        
  end
  
end
