class UserMailer < ApplicationMailer
	def welcome_email(user)
	    @user = user
	    @url  = 'localhost:3000'
	    # change to heroku site in production.
	    mail(to: @user.email, subject: 'Welcome to CarpeDiem!')
  	end

    def create_event_email(event)
      @event = event
      mail(to: User.find(event.creator_id).email, subject: 'Event created successfully!')
    end

    def signup_event_email(user, event)
      @event = event
      @user = user
      mail(to: user.email, subject: 'Event Signup!')
    end

    def update_event_email(event)
      @event = event
      emails = [User.find(event.creator_id).email]
      event.users.each do |u|
        emails.push(u.email)
      end
      mail(to: emails, subject: 'Event updated!')
    end

  	def cancel_event_email(event)
      @event = event
  		user_emails = event.users
      emails = [User.find(event.creator_id).email]
      event.users.each do |u|
        emails.push(u.email)
      end
  		mail(to: emails, subject: 'Event cancelled!')
  	end

end
