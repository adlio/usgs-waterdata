require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe USGS::Gauge do

  it 'should get mean flow data for a river' do
    gauge = USGS::Gauge.new(13336500)
    mean_flow = gauge.get_statistical_mean_flows
    mean_flow.each do |record|
      puts "Mean flow for the Selway River on #{record[0].strftime("%d %b")} is #{record[1]} CFS"
    end
  end

  it 'should get median flow data for a river' do
    gauge = USGS::Gauge.new(13336500)
    median_flow = gauge.get_statistical_median_flows
    median_flow.each do |record|
      puts "Median flow for the Selway River on #{record[0].strftime("%d %b")} is #{record[1]} CFS"
    end
  end

  it 'should get 80th percentile flow data for a river' do
    gauge = USGS::Gauge.new(13336500)
    percentile80_flow = gauge.get_statistical_percentile80_flows
    percentile80_flow.each do |record|
      puts "80th percentile flow for the Selway River on #{record[0].strftime("%d %b")} is #{record[1]} CFS"
    end
  end

  it 'should get 20th percentile flow data for a river' do
    gauge = USGS::Gauge.new(13336500)
    percentile20_flow = gauge.get_statistical_percentile20_flows
    percentile20_flow.each do |record|
      puts "20th percentile flow for the Selway River on #{record[0].strftime("%d %b")} is #{record[1]} CFS"
    end
  end

  it 'should get daily mean flows for a river' do
    gauge = USGS::Gauge.new(13336500)
    daily_mean_flows = gauge.get_daily_mean_flows
    daily_mean_flows.each do |record|
      puts "Daily mean flow for the Selway River on #{record[0].strftime("%d %b %Y")} is #{record[1]} CFS"
    end
  end

  it 'should get the current flow for a river' do
    gauge = USGS::Gauge.new(13336500)
    puts "Latest flow for the Selway River is #{gauge.latest_flow} CFS"
  end

end

