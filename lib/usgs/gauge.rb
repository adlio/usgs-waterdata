module USGS

  require 'open-uri'

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

    # Obtain statistical data for a gauge from the USGS site and store it internally
    def populate_statistical_data

      #todo: populate the URL with gauge-specific data. 
      #For this to work, we need to figure out how to obtain valid dates for a station
      url = "http://waterdata.usgs.gov/id/nwis/dvstat/?site_no=13247500&por_13247500_2=1155369,00060,2,1906-10-01,2008-05-04&start_dt=1906-10-01&end_dt=2008-05-04&format=rdb&date_format=YYYY-MM-DD"

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
      
      mean_flow_hash = {}
      median_flow_hash = {}
      percentile20_flow_hash = {}
      percentile80_flow_hash = {}
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

        tm = Time.mktime(2000, month, day)
        mean_flow_hash[tm] = mean
        median_flow_hash[tm] = median
        percentile20_flow_hash[tm] = percentile20
        percentile80_flow_hash[tm] = percentile80
      end

      @mean_flow = mean_flow_hash.sort
      @median_flow = median_flow_hash.sort
      @percentile20_flow = percentile20_flow_hash.sort
      @percentile80_flow = percentile80_flow_hash.sort


    end

    # todo: use lambda (or a similar construct) to minimize repetitive code

    # Obtain the mean flow for this guage on a particular day and month. If 
    # the parameter is nil, return a 2-dimensional array of the mean flows
    # on days for which data exists.  The array is sorted by date.
    def get_mean_flow(day_and_month = nil)
      populate_statistical_data if @mean_flow.nil? or @mean_flow.empty?

      #todo: handle a specific day and month
      @mean_flow
    end

    
    # Obtain the median flow for this guage on a particular day and month. If 
    # the parameter is nil, return a 2-dimensional array of the median flows
    # on days for which data exists. The array is sorted by date.
    def get_median_flow(day_and_month = nil)
      populate_statistical_data if @median_flow.nil? or @median_flow.empty?

      #todo: handle a specific day and month
      @median_flow
    end

    
    # Obtain the 80th percentile flow for this guage on a particular day and month. If 
    # the parameter is nil, return a 2-dimensional array of the 80th percentile flows
    # on days for which data exists.  The array is sorted by date.
    def get_percentile80_flow(day_and_month = nil)
      populate_statistical_data if @percentile80_flow.nil? or @percentile80_flow.empty?

      #todo: handle a specific day and month
      @percentile80_flow
    end

    
    # Obtain the 80th percentile flow for this guage on a particular day and month. If 
    # the parameter is nil, return a 2-dimensional array of the 80th percentile flows
    # on days for which data exists.  The array is sorted by date.
    def get_percentile20_flow(day_and_month = nil)
      populate_statistical_data if @percentile20_flow.nil? or @percentile20_flow.empty?

      #todo: handle a specific day and month
      @percentile20_flow
    end

  end
end


