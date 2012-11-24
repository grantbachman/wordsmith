desc "This task sends out the daily emails"

task :send_quizzes => :environment do
	puts "Sending out quizzes..."
	User.all.each do |user|
		if Time.zone.now.in_time_zone(user.quiz_time_zone).hour == user.quiz_time
			QuizMailer.quiz_email(user).deliver
		end
	end	
end
