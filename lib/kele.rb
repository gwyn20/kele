require 'httparty'
require 'json'
require 'byebug'
require './lib/roadmap'

class Kele
    include HTTParty
    include Roadmap
    base_uri 'https://www.bloc.io/api/v1'
    
    def initialize(email, password)
        response = self.class.post('/sessions', body: {"email": email, "password": password})
        @auth_token = response["auth_token"]
        if @auth_token.nil?
            puts "Invalid Email or Username"
        end
    end

    def get_me
        response = self.class.get('/users/me', headers: { "authorization" => @auth_token })
        @user = JSON.parse(response.body)
    end

    def get_mentor_availability(mentor_id)
        response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
        @mentor_availability = JSON.parse(response.body)
    end

    def get_messages(page = nil)
        if page != nil
            response = self.class.get('/message_threads', body: {"page": page}, headers: { "authorization" => @auth_token })
        else
            response = self.class.get('/message_threads', headers: { "authorization" => @auth_token })
        end
        @messages = JSON.parse(response.body)
    end

    def create_message(sender, recipient_id, subject, stripped_text)
        response = self.class.post('/messages', body: {"sender": sender, "recipient_id": recipient_id, "subject": subject, "stripped_text": stripped_text}, headers: { "authorization" => @auth_token })
        @message = JSON.parse(response.body)
    end

    def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
        response = self.class.post('/checkpoint_submissions', body: {"assignment_branch": assignment_branch, "assignment_commit_link": assignment_commit_link, "checkpoint_id": checkpoint_id, "comment": comment, "enrollment_id": enrollment_id}, headers: { "authorization" => @auth_token })
        @submission = JSON.parse(response.body)
    end
end
