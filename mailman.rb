require 'mailman'
require './core'

Mailman.config.rails_root = nil
Mailman.config.maildir = "./mail"

Mailman::Application.run do
  to /((?:jessestuart)|(?:deviousxster))((?<=\+)[^@]*)?@gmail\.com/ do |username, list|
    m = Message.new(
      :received_at => Time.now.utc,
      :to          => message.to,
      :from        => message.from,
      :sender      => message.sender,
      :cc          => message.cc,
      :subject     => message.subject,
      :date        => message.date.to_time
    )

    unless message.multipart?
      m.body = message.body.decoded
    else
      m.html = message.html_part
      m.body = message.parts.select { |p| p.content_type =~ /text\/plain/ }.map { |p| p.body.decoded }.join("\n")

      message.attachments.each do |a|
        m.attachments << {
          :name         => a.filename,
          :content_type => a.content_type.split(";").first,
          :data         => a.encoded
        }
      end
    end

    m.save || throw("message not saved!\n\t#{message.inspect}\n\t#{m.inspect}")
  end
end
