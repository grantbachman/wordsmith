ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => MY_CONFIG[:sendgrid][:username],
  :password       => MY_CONFIG[:sendgrid][:password],
  :domain         => 'heroku.com'
}
