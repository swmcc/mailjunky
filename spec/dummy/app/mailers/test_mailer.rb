# frozen_string_literal: true

class TestMailer < ActionMailer::Base
  default from: "test@example.com"

  def welcome(to:)
    mail(to: to, subject: "Welcome!", body: "Welcome to the app!")
  end

  def multipart(to:)
    mail(to: to, subject: "Multipart") do |format|
      format.text { "Plain text" }
      format.html { "<h1>HTML</h1>" }
    end
  end
end
