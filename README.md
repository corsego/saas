# Ruby on Rails SaaS boilerplate

[Gumroad course: Learn to build this app](https://gumroad.com/l/ror6saas)

### Core features:

1. Multitenancy - complete implementation of row-based multitenancy with acts_as_tenant
2. Devise invitable - invite users via email
3. Advanced oAuth - connect multiple social accounts for one user
4. Internationalization (i18n) - whole translation guide
5. Authorization (role-based access) without any gems
6. ActiveStorage and AWS S3 - upload files to cloud storage
7. Omnicontacts - feature to import google contacts
8. Plan-based restrictions - limit access to different features
9. Admin dashboard - build an admin interface without any gems
10. Subscriptions engine - fully integrate the SaaS business model
11. Stripe integration - receive subscription payments from users

[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)

### Installation Requirements 
* ruby v 2.7.2 +
* rails 6.0.3 +
* postgresql database
* yarn

### Connected services required
* AWS S3 API - file storage ** in production **
* Google oauth API
* Github oauth API
* Twitter oauth API
* Stripe API

### Installing RoR

```
rvm install ruby-2.7.2
rvm --default use 2.7.2
gem install rails -v 6.0.3
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install postgresql libpq-dev redis-server redis-tools yarn
```

### postgresql setup

```
sudo su postgres
createuser --interactive
ubuntu
y 
exit
```

### Run the app in development

1. Create app
```
git clone https://github.com/corsego/saas
cd saas
bundle
yarn

```
2. IMPORTANT Set up your secret credentials, otherwise you will not be able to run the app:

Go to **config** folder and delete the file `credentials.yml.enc`
```
EDITOR=vim rails credentials:edit
```
and inside the file:
```
aws:
  access_key_id: YOUR_CODE
  secret_access_key: YOUR_CODE

github:
  development:
    id: YOUR_CODE
    secret: YOUR_CODE
  production:
    id: YOUR_CODE
    secret: YOUR_CODE

google:
  id: YOUR_CODE
  secret: YOUR_CODE

development:
  stripe:
    publishable: YOUR_CODE
    secret: YOUR_CODE

production:
  stripe:
    publishable: YOUR_CODE
    secret: YOUR_CODE

twitter:
   id: YOUR_CODE
   secret: YOUR_CODE
```
* `i` = to make the file editable
* :set paste = to disable autoindentation when pasting
* `Ctrl` + `V` = to paste
* `ESC` + `:`` + `w` + `q` + `Enter` = save changes in the file

3. Run the migrations 
```
rails db:create
rails db:migrate
```
To add default data, you can also run 
```
rails db:seed
```
4. Add an admin role to the first user added via seeds:
```
rails c
User.first.update(superadmin: true)
```
Now you can access the superadmin views!

5. Start the server
```
rails s
```
6. Log in with email: `admin@example.com`, password: `admin@example.com`

### Run the app in production
```
heroku create
heroku rename *your-app-name*
heroku git:remote -a *your-app-name*
heroku buildpacks:set heroku/ruby
heroku buildpacks:add -i 1 https://github.com/heroku/heroku-buildpack-activestorage-preview
heroku addons:create sendgrid:starter
heroku config:set RAILS_MASTER_KEY=`cat config/master.key`
git push heroku master
heroku run rails db:migrate
```

If you have troubles running the app or any questions don't hesitate to contact me at hello@corsego.com 🧐 