require 'fileutils'

desc 'Clean all database files'
namespace :db do
  task :clear, [:model] do |task, args|
    model = args.model ? args.model : '**'
    FileUtils.rm Dir["db/#{model}/*.yml"]
  end
end
