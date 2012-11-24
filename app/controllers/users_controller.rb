class UsersController < ApplicationController

	before_filter :authenticate_user!

  def edit 
  	@user = current_user
  	@times = [["7 AM", 7], ["8 AM", 8], ["9 AM", 9], ["10 AM", 10], ["11 AM", 11], ["12 PM", 12], ["1 PM", 13], ["2 PM", 14], ["3 PM", 15], ["4 PM", 16], ["5 PM", 17], ["6 PM", 18], ["7 PM", 19], ["8 PM", 20], ["9 PM", 21], ["10 PM", 22], ["11 PM", 23],["12 AM", 0], ["1 AM", 1], ["2 AM", 2], ["3 AM", 3], ["4 AM", 4], ["5 AM", 5], ["6 AM", 6]]
  	@time_zones = [['Hawaii','Hawaii'],['Alaska','Alaska'],['Pacific Time', 'Pacific Time (US & Canada)'],['Mountain Time', 'Mountain Time (US & Canada)'],['Central Time', 'Central Time (US & Canada)'],['Eastern Time','Eastern Time (US & Canada)']]
  end

  def update
  	@user = current_user 
  	if @user.update_attributes(params[:user])
  		flash[:success] = "Preferences updated."
  		redirect_to root_path
  	else
  		render 'edit'
  	end
  end

end
