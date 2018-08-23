# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'sined@nisap.fr'
  layout 'mailer'
end
