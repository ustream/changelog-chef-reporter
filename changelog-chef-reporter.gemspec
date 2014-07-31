Gem::Specification.new do |s|
  s.name        = "changelog-chef-reporter"
  s.version     = "0.1.0"
  s.authors     = ["Csergo Balint", "Szelcsanyi Gabor"]
  s.email       = ["csergo.balint@ustream.tv"]
  s.homepage    = "https://github.com/ustream/changelog-chef-reporter"
  s.summary     = "A Chef reporter, which reports to changelog"
  s.description = "A Chef reporter, which reports to changelog"
  s.has_rdoc    = false
  s.license     = "WTFPL"

  s.rubyforge_project = "changelog-chef-reporter"

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
