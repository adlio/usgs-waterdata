require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe USGS::WaterData do

  it 'should retrieve data' do
    USGS::WaterData.us_rivers.each do |state, rivers|
      puts "#{state}"
      puts '-' * 60
      rivers.each do |river_name, gauge_ids|
        puts " * #{river_name} => #{gauge_ids.join(', ')}"
      end
    end
  end

end
