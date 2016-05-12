FactoryGirl.define do

  factory :email_from_unknown, class: Mail do
    to 'to_user@email.com'
    from 'From User <from_user@email.com>'
    subject 'email subject'
    body 'Hello!'
  end

  factory :email_from_known, class: Mail do
    to 'to_user@email.com'
    from 'Scott Miller <scott.miller@test.com>'
    subject 'email subject'
    body 'Hello!'
  end

  factory :reply, class: Mail do
    to 'to_user@email.com'
    from  'Scott Miller <scott.miller@test.com>'
    subject "Re: [Helpy Support] #1-Pending private topic"
    body 'Hello!'
  end

  factory :reply_to_closed_ticket, class: Mail do
    to 'to_user@email.com'
    from 'Scott Miller <scott.miller@test.com>'
    subject "Re: [Helpy Support] #3-Closed private topic"
    body 'Hello!'
  end

end
