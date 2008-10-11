module USGS
  class WaterData
    VERSION = '0.0.1'

    class << self

      def update_state(st)
        require 'open-uri'
        url = "http://waterdata.usgs.gov/#{st}/nwis/current/?type=flow&format=rdb"
        open(url).each do |line|
          puts line
        end
      end

    end
    
  end
end
