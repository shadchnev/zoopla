require 'helper'

class TestPropertyRichList < Test::Unit::TestCase
  
  def setup
    @list = Zoopla.new('my_api_key').rich_list
  end
  
  def test_list
    @list.stubs(:fetch_data).returns(@list.send(:parse, api_reply('richlist')))
    richlist = @list.in({:area => 'NW1', :output_type => :outcode, :area_type => :streets })
    assert_equal 'http://www.zoopla.co.uk/property/richlist/london/NW1/camden-town-regents-park-marylebone-north', richlist.richlist_url
    assert_equal 'http://www.zoopla.co.uk/property/richlist/london/NW1/camden-town-regents-park-marylebone-north', richlist.url
    highest = richlist.highest
    lowest = richlist.lowest
    assert_equal 20, highest.length
    assert_equal 'Park Square East, London NW1', highest.first.name
    assert_equal 5174714, highest.first.zed_index
    assert_equal 'http://www.zoopla.co.uk/home-values/london/park-square-east', highest.first.details_url
    assert_equal 20, lowest.length
    assert_equal 'Wrotham Road, London NW1', lowest.first.name
    assert_equal 200353, lowest.first.zed_index
    assert_equal 'http://www.zoopla.co.uk/home-values/london/wrotham-road-nw1', lowest.first.details_url
  end

end