class QuizMailer < ActionMailer::Base
  default from: "Quiz@wordsmith.mailgun.org"

	def welcome_email(user)
		mail(to: user.email, subject: "Welcome to Wordsmith!")
	end

	def quiz_email(user)

		@quiz = user.quizzes.create
		@questions = @quiz.questions.all(order: "number")
		@word_bank = @quiz.word_bank.split(',')

		mail(to: user.email, subject: "#{Date.today.strftime("%A")}'s quiz has arrived.")
	end

end
