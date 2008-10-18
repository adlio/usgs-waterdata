module USGS

  require 'open-uri'
  require 'date'
  require 'rexml/document'

  class Gauge

    attr_reader :site_number

    def initialize( site_number )
      @site_number = site_number
    end

    # Determine the most recent instantaneous flow in CFS for this guage
    def latest_flow
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

    # todo: use lambda (or a similar construct) to minimize repetitive code

    # Returns a 2-dimensional array of the statistical mean flows for this
    # gauge on days for which data exists, sorted by date.
    def get_statistical_mean_flows
      populate_statistical_data if @statistical_mean_flows.nil? or @statistical_mean_flows.empty?
      @statistical_mean_flows
    end

    # Returns a 2-dimensional array of the statistical median flows for this
    # gauge on days for which data exists, sorted by date.
    def get_statistical_median_flows
      populate_statistical_data if @statistical_median_flows.nil? or @statistical_median_flows.empty?
      @statistical_median_flows
    end
    
    # Returns a 2-dimensional array of the statistical 80th percentile flows for this
    # gauge on days for which data exists, sorted by date.
    def get_statistical_percentile80_flows
      populate_statistical_data if @statistical_percentile80_flows.nil? or @statistical_percentile80_flows.empty?
      @statistical_percentile80_flows
    end
    
    # Returns a 2-dimensional array of the statistical 20th percentile flows for this
    # gauge on days for which data exists, sorted by date.
    def get_statistical_percentile20_flows
      populate_statistical_data if @statistical_percentile20_flows.nil? or @statistical_percentile20_flows.empty?
      @statistical_percentile20_flows
    end

    # Returns a 2-dimensional array of the daily mean flows for this
    # gauge on days for which data exists, sorted by date.
    def get_daily_mean_flows(begin_dt = Date.new(1880, 1, 1), end_dt=nil)

      end_dt = begin_dt if end_dt.nil?
      begin_dt, end_dt = end_dt, begin_dt if end_dt < begin_dt

      populate_daily_data(begin_dt, end_dt) if @daily_mean_flows.nil? or @daily_mean_flows.empty?
      populate_daily_data(begin_dt, end_dt) if (begin_dt < @daily_mean_flows.first[0] or end_dt > @daily_mean_flows.last[0])

      @daily_mean_flows
    end

    # Return the latitude and longitude for this gauge
    def get_lat_lon
      populate_site_data if @lat_lon.nil? or @lat_lon.empty?
      @lat_lon
    end

    # Return the site name for this gauge
    def get_site_name
      populate_site_data if @site_name.nil? or @site_name.empty?
      @site_name
    end

    private

    # Populate daily data for a gauge from the USGS site
    def populate_daily_data(begin_dt = Date.new(1880, 1, 1), end_dt=nil)

      oldest_dt = Date.new(1880, 1, 1)
      newest_dt = Date.today

      begin_dt = oldest_dt if begin_dt < oldest_dt
      begin_dt = newest_dt if begin_dt > newest_dt

      end_dt = begin_dt if end_dt.nil?
      end_dt = oldest_dt if end_dt < oldest_dt

      end_dt = oldest_dt if end_dt < oldest_dt
      end_dt = newest_dt if end_dt > newest_dt

      begin_dt, end_dt = end_dt, begin_dt if end_dt < begin_dt

      url = "http://waterdata.usgs.gov/nwis/dv?site_no=#{@site_number}&cb_00060=on&begin_date=#{begin_dt.strftime("%Y-%m-%d")}&end_date=#{end_dt.strftime("%Y-%m-%d")}&format=rdb"
      mean_flows_hash = {}  
      open(url).each do |line|
        next if line =~ /^#/
        next if line =~ /^5/
        next if line =~ /^agency/

        field_array = line.split(/\t/)
        date_array = field_array[2].split('-')
        date = Date.new(date_array[0].to_i, date_array[1].to_i, date_array[2].to_i)
        mean = field_array[3]
        mean_flows_hash[date] = mean
      end
      @daily_mean_flows = mean_flows_hash.sort
    end

    # Populate statistical data for a gauge from the USGS site
    def populate_statistical_data
      url = "http://waterdata.usgs.gov/id/nwis/dvstat/?site_no=#{@site_number}&por_#{@site_number}_2=1155369,00060,2,0000-01-01,9999-01-01&start_dt=0000-01-01&end_dt=9999-01-01&format=rdb&date_format=YYYY-MM-DD"

      field_map = { 
        'agency' => 0, 
        'site' => 1, 
        'parameter' => 2, 
        'dd_nu' => 3, 
        'month_nu' => 4, 
        'day_nu' => 5, 
        'begin_yr' => 6, 
        'end_yr' => 7, 
        'count_nu' => 8, 
        'max_va_yr' => 9, 
        'max_va' => 10, 
        'min_va_yr' => 11,
        'min_va' => 12,
        'mean_va' => 13,
        'p05_va' => 14,      # 05 percentile of daily mean values for this day.
        'p10_va' => 15,      # 10 percentile of daily mean values for this day.
        'p20_va' => 16,      # 20 percentile of daily mean values for this day.
        'p25_va' => 17,      # 25 percentile of daily mean values for this day.
        'p50_va' => 18,      # 50 percentile (median) of daily mean values for this day.
        'p75_va' => 19,      # 75 percentile of daily mean values for this day.
        'p80_va' => 20,      # 80 percentile of daily mean values for this day.
        'p90_va' => 21,      # 90 percentile of daily mean values for this day.
        'p95_va' => 22       # 95 percentile of daily mean values for this day.
      }
      
      mean_flows_hash = {}
      median_flows_hash = {}
      percentile20_flows_hash = {}
      percentile80_flows_hash = {}
      open(url).each do |line|
        next if line =~ /^#/
        next if line =~ /^5/
        next if line =~ /^agency/
        next if line =~ /^\s/

        field_array = line.split(/\t/)
        month = field_array[field_map['month_nu']]
        day = field_array[field_map['day_nu']]
        mean = field_array[field_map['mean_va']]
        median = field_array[field_map['p50_va']]
        percentile20 = field_array[field_map['p20_va']]
        percentile80 = field_array[field_map['p80_va']]

        d = Date.new(1500, month.to_i, day.to_i)
        mean_flows_hash[d] = mean
        median_flows_hash[d] = median
        percentile20_flows_hash[d] = percentile20
        percentile80_flows_hash[d] = percentile80
      end

      @statistical_mean_flows = mean_flows_hash.sort
      @statistical_median_flows = median_flows_hash.sort
      @statistical_percentile20_flows = percentile20_flows_hash.sort
      @statistical_percentile80_flows = percentile80_flows_hash.sort
    end

    def populate_site_data
      
      url = "http://waterservices.usgs.gov/NWISQuery/GetDV1?SiteNum=#{@site_number}&ParameterCode=00060&StatisticCode=00003&StartDate=2000-11-16&EndDate=2000-11-17&action=Submit"
      doc = REXML::Document.new(open(url))

      @lat_lon = [0.00, 0.00]
      REXML::XPath.each(doc, "//latitude") {|el| @lat_lon[0] = el.text.to_f}
      REXML::XPath.each(doc, "//longitude") {|el| @lat_lon[1] = el.text.to_f}

      @site_name = ""
      REXML::XPath.each(doc, "//siteName") {|el| @site_name = el.text}
    end
  end
end


