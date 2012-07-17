class IncomingEmailsController < ApplicationController

	def create
		sender = params['from']
		subject = params['subject']	
		actual_body = params["stripped-text"]
	end

end
