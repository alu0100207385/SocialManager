task :default => :tests

desc "Run the chat server"
task :server do
  sh "bundle exec ruby app.rb"
end

desc "Run the server via Sinatra"
task :sinatra do
  sh "ruby app.rb"
end

desc "Run the server via rackup"
task :rackup do
  sh "rackup"
end

desc "Open app in Heroku"
task :heroku do
   sh "heroku open"
end

desc "Run tests"
task :tests => :spec do
   sh "ruby test/test.rb"
end

desc "Run tests in local machine"
task :local_tests do
   sh "gnome-terminal -x sh -c 'ruby app.rb' && sh -c 'ruby test/test.rb local'"
end

desc "Open repository"
task :repo do
  sh "gnome-open https://github.com/alu0100207385/SocialManager"
end

desc "Run coveralls"
task :coveralls do
  sh "coveralls report"
end

desc "Run tests with rspec"
task :spec do
  sh "rspec -I. spec/app_spec.rb"
end

desc "Run Rubocop static code analyzer"
task :rubocop do
  sh "rubocop"
end
