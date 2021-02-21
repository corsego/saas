source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

gem "rails", "~> 6.1.0"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 4.1"
gem "sass-rails", ">= 6"
gem "webpacker", "~> 4.0"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.7"
gem "bootsnap", ">= 1.4.2", require: false

group :development do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  # automatically format code to be inline with guidelines
  # bundle exec standardrb --fix
  gem "standard" 
  gem "annotate"
end

# multitenancy
# gem "devise"
gem "devise", github: "heartcombo/devise", branch: "master"
gem "simple_form"
gem "devise_invitable", "~> 2.0.0"
gem "acts_as_tenant"
# replace with UUID by default?
gem "friendly_id"

# storage
gem "active_storage_validations" # tenant logo
gem "aws-sdk-s3", require: false

group :production do
  gem "exception_notification" # send emails if users receive errors in production
end

gem "invisible_captcha" # recaptcha without google

# gem "omniauth", "~> 1.9", ">= 1.9.1"
# gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-github"
gem "omniauth-twitter"
gem "omniauth-facebook"
gem "omniauth-rails_csrf_protection" # for omniauth 2.0

gem "omnicontacts" # additional functionality for importing contacts from social accounts

# i18n
gem "rails-i18n", "~> 6.0.0" # For 6.0.0 or higher
gem "devise-i18n"

gem "stripe"

gem "ransack", github: "activerecord-hackery/ransack"
