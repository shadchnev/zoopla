require 'helper'

class TestZedIndex < Test::Unit::TestCase
  
  def setup
    @zed_index = Zoopla.new('my_api_key').zed_index
  end
  
  def test_in
    @zed_index.stubs(:fetch_data).returns(@zed_index.send(:parse, api_reply('zed_index')))
    index_set = @zed_index.in({:postcode => 'E1'})
    assert_equal 'http://www.zoopla.co.uk/home-values/london/NW1/camden-town-regents-park-marylebone-north', index_set.area_url
    assert_equal '601772', index_set.latest
    assert_equal '601772', index_set.zed_index
    # the values below shouldn't be nil. I addressed this issue on the dev forum: http://developer.zoopla.com/forum/read/106894
    assert_nil index_set.zed_index_3month
    assert_nil index_set.zed_index_6month
    assert_nil index_set.zed_index_1year
    assert_nil index_set.zed_index_2year
    assert_nil index_set.zed_index_3year
    assert_nil index_set.zed_index_4year
    assert_nil index_set.zed_index_5year
  end
  
  def test_invalid_output_type    
    assert_raise Zoopla::InvalidOutputTypeError do
      @zed_index.send(:check_output_type, {:output_type => :street})
    end
    assert_raise Zoopla::InvalidOutputTypeError do
       @zed_index.send(:check_output_type, {:output_type => :postcode})
    end
    assert_raise Zoopla::InvalidOutputTypeError do
       @zed_index.send(:check_output_type, {:output_type => :area})
    end
    assert_nothing_raised { @zed_index.send(:check_output_type, {:output_type => :outcode}) }
    assert_nothing_raised { @zed_index.send(:check_output_type, {:output_type => :town}) }
    assert_nothing_raised { @zed_index.send(:check_output_type, {:output_type => :county}) }
    assert_nothing_raised { @zed_index.send(:check_output_type, {:output_type => :country}) }
  end
  
  
end