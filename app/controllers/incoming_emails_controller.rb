class IncomingEmailsController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def create
		if (params['from'].include?("grantbachman@gmail.com"))
			user = User.find_by_email("grantbachman@gmail.com")
			word = user.words.build(name: "success")
			word.save	
		else
			render text: "This is bad."
		end
	end

	def index
		render text: "This is text. I have spoken."
	end

end
