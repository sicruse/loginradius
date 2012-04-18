require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('loginradius', '0.1.4') do |p|
  p.description     = "Enables token authentication against loginradius.com"
  p.url             = "http://github.com/sicruse/loginradius"
  p.author          = "Si Cruse"
  p.email           = "si@mindcultivator.com"
  p.ignore_pattern  = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }