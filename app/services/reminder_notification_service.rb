class reminderNotificationService

  attr_reader :reminder, :content_type

  def initialize(reminder, content_type)
    @reminder = reminder
    @content_type = content_type
  end

  def call(content, action)
    recipients_with_errors = send_notifications!(content, action)
    ServiceResult.new(success: recipients_with_errors.empty?, errors: recipients_with_errors)
  end

  private

  def send_notifications!(content, action)
    author_mail = reminder.author.mail
    do_not_notify_author = reminder.author.pref[:no_self_notified]

    recipients_with_errors = []
    reminder.participants.each do |recipient|
      begin
        next if recipient.mail == author_mail && do_not_notify_author
        reminderMailer.send(action, content, content_type, recipient.mail).deliver_now
      rescue => e
        Rails.logger.error {
          "Failed to deliver #{action} notification to #{recipient.mail}: #{e.message}"
        }
        recipients_with_errors << recipient
      end
    end

    recipients_with_errors
  end
end
