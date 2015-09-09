require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'engine_cart/rake_task'
require 'rubocop/rake_task'

desc 'Run style checker'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

desc 'Run test suite and style checker'
task spec: :rubocop do
  RSpec::Core::RakeTask.new(:spec)
end

task ci: ['engine_cart:generate'] do
  puts 'running continuous integration'

  error = Jettywrapper.wrap(jetty_params) do
    Rake::Task['spec'].invoke
  end
  fail "test failures: #{error}" if error
end

task clean: 'engine_cart:clean'
task default: :ci
