require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe USGS::Gauge do

  it 'should get mean flow data for a river' do
    gauge = USGS::Gauge.new(13247500)
    mean_flow = gauge.get_mean_flow
    mean_flow.each do |record|
      puts "Mean flow for the Main Payette on #{record[0].strftime("%d %b")} is #{record[1]} CFS"
    end
  end

  it 'should get median flow data for a river' do
    gauge = USGS::Gauge.new(13247500)
    median_flow = gauge.get_median_flow
    median_flow.each do |record|
      puts "Median flow for the Main Payette on #{record[0].strftime("%d %b")} is #{record[1]} CFS"
    end
  end

  it 'should get 80th percentile flow data for a river' do
    gauge = USGS::Gauge.new(13247500)
    percentile80_flow = gauge.get_percentile80_flow
    percentile80_flow.each do |record|
      puts "80th percentile flow for the Main Payette on #{record[0].strftime("%d %b")} is #{record[1]} CFS"
    end
  end


  it 'should get 20th percentile flow data for a river' do
    gauge = USGS::Gauge.new(13247500)
    percentile20_flow = gauge.get_percentile20_flow
    percentile20_flow.each do |record|
      puts "20th percentile flow for the Main Payette on #{record[0].strftime("%d %b")} is #{record[1]} CFS"
    end
  end

  it 'should get the current flow for a river' do
    gauge = USGS::Gauge.new(13247500)
    puts "Latest flow for the Main Payette is #{gauge.latest_flow} CFS"
  end

end

