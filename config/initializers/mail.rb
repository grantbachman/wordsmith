ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
	:address        => 'smtp.mailgun.org',
  :port           => '587',
  :authentication => :plain,
  :user_name      => MY_CONFIG[:mailgun][:username],
  :password       => MY_CONFIG[:mailgun][:password],
  :domain         => 'wordsmith.mailgun.org'

}
