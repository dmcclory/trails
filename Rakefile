require 'rake'
require 'rake/testtask'


Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = FileList["test/*.rb"]
  t.verbose = true
end

task :spec do
  puts `rspec`
end

task :default => [:spec, :test]
