module USGS

  class Gauge
    VERSION = '0.0.1'

    attr_reader :site_number

    def initialize( site_number )
      @site_number = site_number
    end

    # Determine the most recent instantaneous flow in CFS for this guage
    def latest_flow
      require 'open-uri'

      url = "http://waterdata.usgs.gov/nwis/uv?cb_00060=on&format=rdb&period=1&site_no=#{@site_number}"
      flow = 0
      open(url).each do |line|
        next if line =~ /^#/
        next if line =~ /^5/
        next if line =~ /^agency/

        fields = line.split(/\t/)
        flow = fields[3]
      end
      flow
    end

    # Determine the long term median flow for a particular day
    def median_flow( day_month = Time.now )
    end

  end
end


