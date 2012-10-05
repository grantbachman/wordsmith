desc "This task sends out the daily emails"

task :send_quizzes => :environment do
	puts "Sending out quizzes..."
	User.each do |user|
		QuizMailer.quiz_email(user)	
	end
	
end
