# Built for **_Low Country Open Land Trust_**

## Let the angel keep the change
![alt text](http://www.lolt.org/images/header/logo.png "Low Country Open Land Trust")

## Prerequisites:
Make sure you have installed the following

###### Rails 3.2.14
###### Ruby 9.2
###### MongoDB
###### [AWS account](http://aws.amazon.com)
###### [Stripe account](https://www.stripe.com)


## Installation:

Install the required gems:

```
$ bundle install
```

Seed data:

```
$ rake db:seed
```

Set the required [AWS](http://aws.amazon.com) and [Stripe](https://www.stripe.com) environment variables:

```
$ export access_key_id="Your Access Key"
$ export secret_access_key="Secret Access Key"

$ export stripe_publishable_key=" ... "
$ export stripe_secret_key=" ... "
```


## Start the Server

```
$ rails server
```

