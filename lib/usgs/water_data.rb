module USGS
  class WaterData

    class << self

      def us_rivers
        states = %w{al ar az ca co ct dc de fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt nc nd ne nh nj nm nv ny oh ok or pa ri sc sd tn tx ut va vt wa wi wv wy}
        state_rivers = {}
        states.each do |state|
          STDOUT.write("#{state} ") # REMOVE THIS REMOVE THIS REMOVE THIS
          STDOUT.flush
          state_rivers[state] = rivers_in_state(state)
        end
        state_rivers
      end


      def rivers_in_state(st)
        require 'open-uri'

        url = "http://waterdata.usgs.gov/#{st}/nwis/current/?type=flow&format=rdb"
        rivers = {}

        open(url).each do |line|
          next if line =~ /^#/
          next if line =~ /^5/
          next if line =~ /^agency/

          fields = line.split(/\t/)
          station_name = fields[2]
          name_parts = station_name.split(/\b([A-Z]+ OF|ABV|AT|NR|NEAR|DS OF|US OF|ABOVE|BELOW|BEL|BL|BLW|AB|ABV)\b/i)
          river_name = clean_river_name(name_parts[0])

          rivers[river_name] ||= []
          rivers[river_name] << fields[1]
        end

        rivers
      end


      # Given a river name from the USGS site, a clean and 
      # normalized river name is returned.
      #
      def clean_river_name(river_name)
        val = river_name.strip.downcase.gsub(/\b('?[a-z])/) { $1.capitalize }
        val.gsub!(/d'?\s*alene/i, "d'Alene")
        val.gsub!(/[^A-Za-z' ]/, '')
        val.gsub!(/\bSf\b/, 'South Fork')
        val.gsub!(/\bMf\b/, 'Middle Fork')
        val.gsub!(/\bNf\b/, 'North Fork')
        val.gsub!(/\bDiv\b/, 'Diversion')
        val.gsub!(/\bCrk?\b/, 'Creek')
        val.gsub!(/\bC\b/, 'Creek')
        val.gsub!(/\bR\b/, 'River')
        val.gsub!(/\bBra?(nch)?\b/, 'Branch')
        val.gsub!(/\bRvr\b/, 'River')
        val.gsub!(/\bTrib\b/, 'Tributary')
        val.gsub!(/\bSprngs\b/, 'Springs')
        val
      end

    end
    
  end
end
