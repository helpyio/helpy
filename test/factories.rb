FactoryGirl.define do

  factory :email_from_unknown, class: OpenStruct do
    # Assumes Griddler.configure.to is :hash (default)
    to [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }]
    from({ token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: 'From User <from_user@email.com>', name: 'From User' })
    subject 'email subject'
    body 'Hello!'
  end

  factory :email_from_known, class: OpenStruct do
    # Assumes Griddler.configure.to is :hash (default)
    to [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }]
    from({ token: 'scott', host: 'test.com', email: 'scott.miller@test.com', full: 'Scott Miller <scott@test.com>', name: 'Scott Miller' })
    subject 'email subject'
    body 'Hello!'
  end

  factory :reply, class: OpenStruct do
    # Assumes Griddler.configure.to is :hash (default)
    to [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }]
    from({ token: 'scott', host: 'test.com', email: 'scott.miller@test.com', full: 'Scott Miller <scott@test.com>', name: 'Scott Miller' })
    subject "Re: [Helpy Support] #1-Pending private topic"
    body 'Hello!'
  end
end
