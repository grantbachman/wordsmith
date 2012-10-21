class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_no_cache

  # Prevent pages from caching. This prevents users from being able to hit
  # the back button when taking quizzes to resubmit them.
  def set_no_cache
  	response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
  	response.headers["Pragma"] = "no-cache"
  	response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

end
