# Built for **Low Country Open Land Trust**
![alt text](http://www.lolt.org/images/header/logo.png "Low Country Open Land Trust")

## Prerequisites:
Make sure you have installed the following

###### Rails 3.2.14
###### Ruby 9.2
###### MongoDB


## Installation:

Install the required gems:

```ruby
$ bundle install
```

Seed data:

```ruby
$ rake db:seed
```

Set the required [AWS](http://aws.amazon.com) and [Stripe](https://www.stripe.com) environment variables:

```ruby
$ export access_key_id="Your Access Key"
$ export secret_access_key="Secret Access Key"

$ export stripe_publishable_key=" ... "
$ export stripe_secret_key=" ... "
```


## Start the Server

```ruby
$ rails server
```

