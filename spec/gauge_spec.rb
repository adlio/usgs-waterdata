require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe USGS::Gauge do

  it 'should get the current flow for a river' do
    gauge = USGS::Gauge.new(13317000)
    puts '-' * 60
    puts "Latest flow for the Salmon River at White Bird is #{gauge.latest_flow} CFS"
    puts '-' * 60
  end

end

