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
11. BONUS: PWA from the box!
12. BONUS: Omnicontacts - feature to import google contacts

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

Using VIM as an editor. You could change editors' name to your choice such as: `code`, `atom` or `sublime`

`--wait` opens up credential file in your editor to alter it then save it on exit or close. Not using it would open, save and close your editor before you apply any changes.

Using VIM as an editor. You could change editors' name to your choice such as: `code`, `atom` or `sublime`
`--wait` opens up credential file in your editor. Not using it would open, save and close your editor before you apply any changs.

```
EDITOR="vim --wait" rails credentials:edit
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
* Improve current PWA functionality?
* subscriptions: trial period option?
* better dark mode css. & here you start thinking of tailwind...
* bootstrap css - sidebar to collapse into navbar based on screen size

### TODO - ideas

* can not delete self if only admin in a tenant
* plan/form - explicitly say `price_cents`
* user has to accept/reject invitation to become a member of a tenant? - would be good
* improve omniauth flow? (social email changed, but identity connected to old user model) - would be good
* better SEO from the box - would be good
* form_with instead of simple_form? - to think alongside hotwire
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

SaaS subscriptions flow:
* to access app functionality (specific controllers), a user has to be subscribed with an active subscription.
* user selects plan and creates subscription with an `ends_at: Time.now`.
* a subscription is `active` if the `ends_at` is in the future.
* to activate/resume subscription, user has to pay `Plan.amount`
* one-time payment via Stripe.
* if payment is successful, `subscription.ends_at` is delayed by `Plan.interval`
* if a user cancels a subscription, subscription is deleted & he can not access the specific controllers.

There are 2 payment collection methods:
* send invoice - send an invoice that a customer has to manually pay
* charge automatically - attempt to bill default connected credit card at period end
=> The default subscription model in the app right now is more like **send invoice** where a user has to pay manually.

Benefits:
* Most simple approach to subscriptions
* User controls his expences: only one-time payments. Good for user budget control :)
Drawbacks:
* No automatic payments: the user has to manually create a payment. Bad for SaaS business.
* No trial period option (yet?)
* Cancelling subscription right now (not at the end of the billing period); No prorating.

Stripe integration is currently working but outdated (legacy checkout).

Work in process on migrating to the new Stripe Checkout Sessions.

****

Possible disadvantages of setting tenant by `current_user.tenant_id` column:
* One user can not open 2 tenants in 2 different tabs
* Tenant is not visible in the URL

Are there any disadvantages in setting tenant in `session` without having `current_user.tenant_id` column?

Disadvantages of subdomain multitenancy - [link](https://www.reddit.com/r/rails/comments/lidwap/realworld_possible_issues_with_subdomain/)

Want to disable invitations? Just don't create Plans that allow more than 1 member.

Not adding ActionText by default - users can add it themselves if they need. Not overbloating the MVP.

Tailwind? I think it is not mature enough.

HAML? I personally prefer haml over erb.
This app uses erb so that it is more approachable to the general public.
You can easily convert erb to haml with `gem "haml-rails"`.

By default, the app uses as little custom css and js as possible

If you are interested in playing around other multitenancy gems, I recommend [activerecord-multi-tenant](https://github.com/citusdata/activerecord-multi-tenant)

### These features should not be part of the core app:

* User feedback
* Feature voting
* Forum
* User wiki
* User onboarding
* Company blog
* Announcements

Why?
* features are not core business
* features are too big to implement in high-quality
* features can be covered by an external service

### Adding a new table that belongs to tenant

1. console
```
rails g scaffold projects name tenant:references
```
2. project.rb
```
  acts_as_tenant :tenant
```
3. `projects_controller.rb` - on the very TOP:
```
  include SetTenant # include ON TOP of controller that has to be scoped
  include RequireTenant # no current_tenant = no access to entire controller. redirect to root
  include SetCurrentMember # for role-based authorization. @current_member.admin?
  include RequireActiveSubscription # no access unless tenant has an active subscription
```
4. `projects_controller.rb` - remove `tenant_id` from strong params

That's it. Now to access the Projects table a user has to:
* have a `current_user`
* have a `current_tenant`
* tenant subscription should be active

Whenever a `project` is created, it will be automatically assigned and scoped to the `current_tenant`

### Alternative names to `tenant`:
* account
* team
* workplace
* organisation

### SaaS ideas:

* Remote worker inventory management
* Content planning & posting tool
* Telehealth
* Collaboration (Trello)
* Appointments (calendly / booksy)
* CRM (KANBAN Trello for people)

### ~~Competitors~~ Similar Ruby on Rails solutions

I don't think that corsego/saas & the other tools should be considered competitors:

I think they can be considered **complimentary** purchases🤯

Each solution has its' own advantages and disadvantages.

By seeing their differences you can create the ideal setup for you.

* jumpstartrails.com - Good
* github.com/archonic/limestone-accounts - Good
* bullettrain.co - overpriced
* www.getsjabloon.com - N/A
* hixonrails.com - N/A
* buildasaasappinrails.com - big NO

All the above tools are inspired by spark.laravel.com


