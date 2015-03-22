Gem::Specification.new do |s|
  s.name        = 'salesforceable'
  s.version     = '0.0.0'
  s.date        = '2015-03-22'
  s.summary     = "Let you insert data into salesforce."
  s.description = "Let you insert data into salesforce using restforce under the hoods."
  s.authors     = ["Murillo Flores"]
  s.files       = ["lib/salesforceable.rb"]
  s.license       = 'MIT'
  s.add_runtime_dependency  'restforce', '1.5.1'
end