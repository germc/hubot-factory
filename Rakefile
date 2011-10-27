require "bundler/gem_tasks"

task :default => :start

desc "Run Thin like a boss"
task :start do
  system "bundle exec thin start"
end

desc "Run Shotgun like a deputy"
task :shotgun do
  system "bundle exec shotgun --host 0.0.0.0 --port 3000"
end
