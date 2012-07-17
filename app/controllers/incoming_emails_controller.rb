class IncomingEmailsController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def create
		sender = params['from']
		subject = params['subject']	
		actual_body = params["stripped-text"]
	end

end
