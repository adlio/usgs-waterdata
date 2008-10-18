require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe USGS::Gauge do

  it 'should get 20th percentile flow data for a river' do
    gauge = USGS::Gauge.new(13336500)
    percentile20_flow = gauge.get_statistical_percentile20_flows
    puts "20th percentile flow for the Selway River:"
    percentile20_flow.each do |record|
      puts "\t#{record[0].strftime("%d %b")} = #{record[1]} CFS"
    end
  end

  it 'should get 50th (median) percentile flow data for a river' do
    gauge = USGS::Gauge.new(13336500)
    median_flow = gauge.get_statistical_median_flows
    puts "50th percentile (median) flow for the Selway River:"
    median_flow.each do |record|
      puts "\t#{record[0].strftime("%d %b")} = #{record[1]} CFS"
    end
  end

  it 'should get 80th percentile flow data for a river' do
    gauge = USGS::Gauge.new(13336500)
    percentile80_flow = gauge.get_statistical_percentile80_flows
    puts "80th percentile flow for the Selway River:"
    percentile80_flow.each do |record|
      puts "\t#{record[0].strftime("%d %b")} = #{record[1]} CFS"
    end
  end

  it 'should get mean flow data for a river' do
    gauge = USGS::Gauge.new(13336500)
    mean_flow = gauge.get_statistical_mean_flows
    puts "Mean flow for the Selway River:"
    mean_flow.each do |record|
      puts "\t#{record[0].strftime("%d %b")} = #{record[1]} CFS"
    end
  end

  it 'should get the current flow for a river' do
    gauge = USGS::Gauge.new(13336500)
    puts "Latest flow for the Selway River is #{gauge.latest_flow} CFS"
  end

  it 'should get daily mean flows for a river' do
    gauge = USGS::Gauge.new(13336500)
    daily_mean_flows = gauge.get_daily_mean_flows
    puts "Daily mean flow for the Selway River"
    daily_mean_flows.each do |record|
      puts "\t #{record[0].strftime("%d %b %Y")} = #{record[1]} CFS"
    end
  end

  it 'should get daily mean flows for a single date' do
    gauge = USGS::Gauge.new(13336500)
    gauge.should_not be_nil
    begin_dt = Date.new(1997,5,31)
    daily_mean_flows = gauge.get_daily_mean_flows(begin_dt)
    daily_mean_flows.should_not be_nil
    daily_mean_flows.size.should be(1)
    puts "Daily mean flow for the Selway River"
    daily_mean_flows.each do |record|
      puts "\t #{record[0].strftime("%d %b %Y")} = #{record[1]} CFS"
    end
  end

  it 'should get daily mean flows for a date range' do
    gauge = USGS::Gauge.new(13336500)
    gauge.should_not be_nil
    begin_dt = Date.new(1997,3,31)
    end_dt = Date.new(1997,7,31)
    daily_mean_flows = gauge.get_daily_mean_flows(begin_dt, end_dt)
    daily_mean_flows.should_not be_nil
    daily_mean_flows.size.should be(123)
    puts "Daily mean flow for the Selway River"
    daily_mean_flows.each do |record|
      puts "\t #{record[0].strftime("%d %b %Y")} = #{record[1]} CFS"
    end
  end

  it 'should handle switched dates' do
    gauge = USGS::Gauge.new(13336500)
    gauge.should_not be_nil
    begin_dt = Date.new(1997,7,31)
    end_dt = Date.new(1997,3,31)
    daily_mean_flows = gauge.get_daily_mean_flows(begin_dt, end_dt)
    daily_mean_flows.should_not be_nil
    daily_mean_flows.size.should be(123)
    puts "Daily mean flow for the Selway River"
    daily_mean_flows.each do |record|
      puts "\t #{record[0].strftime("%d %b %Y")} = #{record[1]} CFS"
    end
  end

  it 'should handle a date that is too old' do
    gauge = USGS::Gauge.new(13336500)
    gauge.should_not be_nil
    begin_dt = Date.new(1797,3,31)
    daily_mean_flows = gauge.get_daily_mean_flows(begin_dt)
    daily_mean_flows.should_not be_nil
    daily_mean_flows.size.should be(1)
    puts "Daily mean flow for the Selway River"
    daily_mean_flows.each do |record|
      puts "\t #{record[0].strftime("%d %b %Y")} = #{record[1]} CFS"
    end
  end

  it 'should handle a date that has not yet occured' do
    gauge = USGS::Gauge.new(13336500)
    gauge.should_not be_nil
    begin_dt = Date.new(Date.today.year, Date.today.month + 1, Date.today.day)
    daily_mean_flows = gauge.get_daily_mean_flows(begin_dt)
    daily_mean_flows.should_not be_nil
    daily_mean_flows.size.should be(1)
    puts "Daily mean flow for the Selway River"
    daily_mean_flows.each do |record|
      puts "\t #{record[0].strftime("%d %b %Y")} = #{record[1]} CFS"
    end
  end

  it 'should handle out-of-range, switched data ' do
    gauge = USGS::Gauge.new(13336500)
    gauge.should_not be_nil
    begin_dt = Date.new(Date.today.year, Date.today.month + 1, Date.today.day)
    end_dt = Date.new(1797,3,31)
    daily_mean_flows = gauge.get_daily_mean_flows(begin_dt, end_dt)
    daily_mean_flows.should_not be_nil
    daily_mean_flows.size.should be(35619)
    puts "Daily mean flow for the Selway River"
    daily_mean_flows.each do |record|
      puts "\t #{record[0].strftime("%d %b %Y")} = #{record[1]} CFS"
    end
  end

  it 'should obtain site information' do
    gauge = USGS::Gauge.new(13336500)
    latlon = gauge.get_lat_lon
    site_name = gauge.get_site_name
    puts "The latitude and longitude for the gauge at #{site_name} is #{latlon[0]}, #{latlon[1]}"
  end

end

