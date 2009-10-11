# gem_info.rb
# TheSafe
#
# Created by Matt Aimonetti on 10/10/09.
# Copyright 2009 m|a agile. All rights reserved.
class GemInfo
 
 attr_reader :name
 
 def initialize(gems_spec_data)
   @name = gems_spec_data.first
   @specs = [gems_spec_data.last]
 end
 
 def versions
   @specs.map{|spec| spec.version.to_s}
 end
 
 def latest_version
   @specs.last.version.to_s
 end
 alias_method :version, :latest_version
 
end

