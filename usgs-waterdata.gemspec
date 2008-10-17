
Gem::Specification.new do |s|
  s.name     = "usgs-waterdata"
  s.version  = "0.0.2"
  s.date     = "2008-10-16"
  s.summary  = "Library for obtaining river flow data."
  s.email    = "ctenbrink@gmail.com"
  s.homepage = "http://github.com/ADLongwell/usgs-waterdata"
  s.description = "A library for obtaining statistical and real-time flows from the Unite States Geological Survey's National Water Information System"
  s.has_rdoc = true
  s.authors  = ["Aaron Longwell", "Chris Tenbrink"]
  s.files    = [ "History.txt",
                 "init.rb",
                 "Manifest.txt",
                 "License.txt",
                 "README.txt",
                 "Rakefile",
                 "lib/usgs.rb",
                 "lib/usgs/gauge.rb",
                 "lib/usgs/water_data.rb" ]
  s.test_files = ["spec/gauge_spec.rb",
                  "spec/spec_helper.rb",
                  "spec/waterdata_spec.rb"]
  s.rdoc_options = ["--main", "README.txt"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
end

