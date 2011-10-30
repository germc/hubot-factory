$: << File.expand_path("../lib", __FILE__) << File.expand_path("../", __FILE__)

require "bundler/setup"
require "resque/tasks"
require "hubot_factory"

task :default => :start

desc "Run Thin like a boss"
task :start do
  system "bundle exec thin start"
end

desc "Run Shotgun like a deputy"
task :shotgun do
  system "bundle exec shotgun --host 0.0.0.0 --port 3000"
end

desc "send test email"
task :email do
  email        = "hello@tombell.org.uk"
  name         = "pickles"
  adapter      = "campfire"
  adapter_vars = [
    { :var => "HEROKU_CAMPFIRE_ACCOUNT", :val => "FOO" },
    { :var => "HEROKU_CAMPFIRE_TOKEN", :val => "BAR" },
    { :var => "HEROKU_CAMPFIRE_ROOMS", :val => "BAZ" }
  ]

  file_path = File.expand_path("../templates/email.mustache", __FILE__)
  template  = IO.read(file_path)
  body      = Mustache.render(template, :name         => name,
                                        :adapter      => adapter,
                                        :adapter_vars => adapter_vars)

  Pony.mail(:to      => email,
            :headers => { "Content-Type" => "text/html" },
            :from    => "hubot@tombell.org.uk",
            :subject => "Your Hubot is Ready",
            :body    => body)
end
