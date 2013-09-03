class EmailTemplate < ActiveRecord::Base
  include Routing

  def generate_email(args)
    headers = args[:headers]
    placeholders = args[:placeholders]

    email = Email.new
    email.email_template = self
    email.recipient = placeholders[:recipient]
    email.subject = substitute_placeholders(subject, placeholders)
    email.body = substitute_placeholders(body, placeholders)
    email.language = language
    email.to = headers[:to]
    email.from = headers[:from]
    email.reply_to = headers[:reply_to]
    email
  end

  def substitute_placeholders(in_text, placeholders)
    out_text = in_text.dup
    subs = substitutions(placeholders)

    subs.each_pair do |placeholder, value|
      out_text.gsub!(placeholder.to_s, value.to_s)
    end

    out_text
  end

  def substitutions(placeholders)
    group = placeholders[:group]
    recipient = placeholders[:recipient]
    author = placeholders[:author]
    subs = {
      recipient_id: recipient.id,
      recipient_first_name: recipient.first_name,
      recipient_name: recipient.name,
      author_id: author.id,
      author_first_name: author.first_name,
      author_name: author.name,
      new_discussion_url: new_discussion_url,
      loomio_url: root_url
    }

    if group
      subs.merge!({ group_id: group.id,
                    group_name: group.name,
                    invite_people_to_group_url: new_group_invitation_url(group),
                    invitation_to_start_group_url: 'http://invitations_url_placeholder/',
                    group_url: group_url(group) })
    end

    if group.pending_invitations.present?
      subs.merge!({invitation_to_start_group_url: invitation_url(group.pending_invitations.first)})
    end
    subs
  end
end