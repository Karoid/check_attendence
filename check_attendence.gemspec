$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "check_attendence/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "check_attendence"
  s.version     = CheckAttendence::VERSION
  s.authors     = ["Karoid"]
  s.email       = ["shj5508@naver.com"]
  s.homepage    = "https://github.com"
  s.summary     = "CheckAttendence gem is checking attendence gem."
  s.description = "CheckAttendence gem is checking attendence gem"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "> 4.2.5.1"

  s.add_development_dependency "sqlite3"
end
