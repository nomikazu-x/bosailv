source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.5'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem 'dotenv-rails'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Devise
gem 'devise', '< 4.8.0'
gem 'devise-i18n'

# Use Devise Token Auth
gem 'devise_token_auth'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Use CarrierWave/MiniMagick
gem 'carrierwave'
gem 'mini_magick'

# Use kaminari
gem 'kaminari'
gem 'kaminari-i18n'

# Use EnumHelp
gem 'enum_help'

# Use Config
gem 'config'

# Use ActiveFlag
gem 'active_flag'

# コンソール出力結果を表にする Doc: https://github.com/cldwalker/hirb
gem 'hirb', '~> 0.7.3'

# コンソール文字列補正 Doc: https://github.com/steakknife/hirb-unicode
gem 'hirb-unicode-steakknife', '~> 0.0.9'

# Use Annotate
gem 'annotate'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Rspec
  gem 'factory_bot_rails'
  gem 'spring-commands-rspec'
  gem 'faker'
  gem 'rspec-rails' # Tips: https://qiita.com/amatsukix/items/578f85cf4565ca2a797c

  #  RuboCop
  gem 'rubocop'
  gem 'rubocop-rails'

  # メール送信確認
  gem 'letter_opener_web', '~> 1.0'

  # デバッグbinding.pry Doc: https://github.com/deivid-rodriguez/pry-byebug
  gem 'pry-byebug', '~> 3.9'
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'sassc-rails'
