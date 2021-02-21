# Ruby on Rails SaaS boilerplate

[Gumroad course: Learn to build this app](https://gumroad.com/l/ror6saas)

### Core features:

1. Multitenancy - complete implementation of row-based multitenancy with acts_as_tenant
2. Devise invitable - invite users via email
3. Advanced oAuth - connect multiple social accounts for one user
4. Internationalization (i18n) - whole translation guide
5. Authorization (role-based access) without any gems
6. ActiveStorage and AWS S3 - upload files to cloud storage
7. Plan-based restrictions - limit access to different features
8. Admin dashboard - build an admin interface without any gems
9. Subscriptions engine - fully integrate the SaaS business model
10. Stripe integration - receive subscription payments from users
11. BONUS: Omnicontacts - feature to import google contacts

[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)

### Installation Requirements 
* ruby v 2.7.2 +
* rails 6.1.0 +
* postgresql database
* yarn

### Connected services required
* AWS S3 API - file storage ** in production **
* Amazon SES for sending emails ** in production ** 
* Google oAuth API
* Github oAuth API
* Twitter oAuth API
* Stripe API

### Installing RoR

```
rvm install ruby-2.7.2
rvm --default use 2.7.2
gem install rails -v 6.1.0
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

2. IMPORTANT: Set up your secret credentials, otherwise you might not be able to run the app:

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

Working with VIM:
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
heroku config:set RAILS_MASTER_KEY=`cat config/master.key`
git push heroku master
heroku run rails db:migrate
```

****

How to MIRROR the repo (not fork) - create a copy with saving the commit history:
[https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/duplicating-a-repository](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/duplicating-a-repository)

If you have troubles running the app or any questions don't hesitate to contact me at hello@corsego.com 🧐 

****

### TODO - prioriry

* better stripe integration, refactor subscriptions and charges controller
* hotwire
* complete i18n coverage
* option to set tenant by subdomain?

### TODO - ideas

* can not delete self if only admin in a tenant
* plan/form - explicitly say `price_cents`
* user has to accept/reject invitation to become a member of a tenant? - would be good
* improve omniauth flow? (social email changed, but identity connected to old user model) - would be good
* form_with instead of simple_form?
* omniauth - one email per user (current), or many emails per user? - to think
* application.scss loaded in 2 places: not best approach? - to think
* plan - replace hard-coded `max_members` to `restrictions`? - needed?
* user can not delete self if only superadmin? - needed?
* user.rb lockable, bannable, deletable? - needed?
* uuid instead of friendly_id? - needed?
* add ransack & pagy-nation to scaffold templates? - needed?
* stimulus by default? - needed?
* option to set tenant from session? - does not add value

### TODO - long-term

* ruby 3.0
* tests
* developer wiki

****

### Notes

Possible disadvantages of setting tenant by current_user.tenant_id column:
* One user can not open 2 tenants in 2 different tabs 
* Tenant is not visible in the URL

notes for omniauth:
```
<% identities = @user.identities.pluck(:provider).map(&:to_sym).intersection(User.omniauth_providers) %>
<% identities = @user.identities.select{ |identity| identity.provider == provider.to_s } %>

<%= @user.identities.pluck(:provider).intersection(User.omniauth_providers.to_s) %>
<%= @user.identities.pluck(:provider).include?(provider.to_s) %>
<% identities = @user.identities.pluck(:provider).include?(provider.to_s) %>

User.find_by(email: "elviramamedo@gmail.com").identities.pluck(:provider).map(&:to_sym)
 => ["google_oauth2"] 
Devise.omniauth_configs.keys
 => [:google_oauth2, :github] 
```

# SaaS ideas:

* Remote worker inventory management
* Content planning & posting tool
* Telehealth
* Collaboration (Trello)
* Appointments (calendly / booksy)
* CRM (KANBAN Trello for people)
