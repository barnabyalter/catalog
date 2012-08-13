source 'http://rubygems.org'

gem 'rails', '~>3.2.1'

gem 'blacklight'
gem 'sqlite3'
gem 'sanitize'
gem 'json'
gem 'jquery-rails'
gem 'rspec-rails'
gem 'sass-rails', '  ~> 3.2.3'
gem 'devise'
gem 'blacklight_highlight'
gem 'blacklight-sitemap', '~> 1.0.0'
gem 'solr_ead', :path => "gems/solr_ead"

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails', '~> 1.0.0'
  gem 'compass-susy-plugin', '~> 0.9.0', :require => 'susy'
end

group :development, :test do
  gem 'webrat'
  gem 'database_cleaner'
  gem 'ruby-debug19'
end

group :cucumber do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'
end

group :production do
  gem 'passenger', '=3.0.13'
end
