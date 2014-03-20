require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = Dir['test/**/*_test.rb']
  t.ruby_opts << '-rubygems'
  t.libs << 'test'
  t.verbose = true
end

task :default => :test
