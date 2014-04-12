Rails.configuration.stripe = {
  :publishable_key => 'pk_test_pBNOofbz6g42WPgUYTLHeJA7', #ENV['stripe_publishable_key'],
  :secret_key      => 'sk_test_MlMeZJrd6e7wTa9PWNkjZz3A'# ENV['stripe_secret_key']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]