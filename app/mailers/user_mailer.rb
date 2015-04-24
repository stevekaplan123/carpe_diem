class UserMailer < ApplicationMailer
	def welcome_email(user)
	    @user = user
	    @url  = 'localhost:3000'
	    # change to heroku site in production.
	    mail(to: @user.email, subject: 'Welcome to CarpeDiem!')
  	end
end
