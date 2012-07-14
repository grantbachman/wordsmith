class QuizMailer < ActionMailer::Base
  default from: "from@example.com"

	def welcome_email(user)
		mail(to: user.email, subject: "Welcome to Wordsmith!")
	end

end
