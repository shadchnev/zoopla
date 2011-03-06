require 'helper'

class TestAreaValueGraphs < Test::Unit::TestCase
  
  def setup
    @area_value_graphs = Zoopla.new('my_api_key').area_value_graphs
  end
  
  def test_in
    @area_value_graphs.stubs(:fetch_data).returns(@area_value_graphs.send(:parse, api_reply('area_value_graphs')))
    index_set = @area_value_graphs.medium.in({:postcode => 'NW1'})
    assert_equal 'http://www.zoopla.co.uk/home-values/london/NW1/camden-town-regents-park-marylebone-north', index_set.area_values_url
    assert_equal 'http://www.zoopla.co.uk/dynimgs/graph/home_value/oc/NW1?width=400&height=212', index_set.home_values_graph_url
    assert_equal 'http://www.zoopla.co.uk/dynimgs/graph/local_type_trends/NW1?width=400&height=212', index_set.value_trend_graph_url
    assert_equal 'http://www.zoopla.co.uk/dynimgs/graph/price_bands/NW1?width=400&height=212', index_set.value_ranges_graph_url
    assert_equal 'http://www.zoopla.co.uk/dynimgs/graph/average_prices/NW1?width=400&height=212', index_set.average_values_graph_url
  end
  
  def test_small_size
    @area_value_graphs.stubs(:fetch_data).returns(@area_value_graphs.send(:parse, api_reply('area_value_graphs_small')))
    index_set = @area_value_graphs.small.in({:postcode => 'NW1'})
    assert_equal 'http://www.zoopla.co.uk/dynimgs/graph/home_value/oc/NW1?width=200&height=106', index_set.home_values_graph_url
  end
  
  def test_larse_size
    @area_value_graphs.stubs(:fetch_data).returns(@area_value_graphs.send(:parse, api_reply('area_value_graphs_large')))
    index_set = @area_value_graphs.large.in({:postcode => 'NW1'})
    assert_equal 'http://www.zoopla.co.uk/dynimgs/graph/home_value/oc/NW1?width=600&height=318', index_set.home_values_graph_url
  end
  
  def test_invalid_output_type    
    assert_raise Zoopla::InvalidOutputTypeError do
      @area_value_graphs.send(:check_output_type, {:output_type => :postcode})
    end
    assert_raise Zoopla::InvalidOutputTypeError do
      @area_value_graphs.send(:check_output_type, {:output_type => :area})
    end
    assert_nothing_raised { @area_value_graphs.send(:check_output_type, {:output_type => :outcode}) }
  end
  
end