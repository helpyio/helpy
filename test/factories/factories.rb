FactoryBot.define do

  factory :email_from_unknown, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: 'From User <from_user@email.com>', name: 'From User' }) }
    subject { 'email subject' }
    header {}
    body { 'Hello!' }
    spam_score { '0.11' }
    spam_report { '' }
  end

  factory :blacklist_email, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'blacklist', host: 'email.com', email: 'blacklist@email.com', full: 'blacklist <blacklist@email.com>', name: 'blacklist User' }) }
    subject { 'spam email subject' }
    header {}
    body { 'Spam' }
  end

  factory :spam_from_unknown, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'spam_user', host: 'email.com', email: 'spammer_email@email.com', full: 'spammer <spam_user@email.com>', name: 'Spam User' }) }
    subject { 'spam email subject' }
    header {}
    body { 'Spam' }
    spam_score { '6.0' }
    spam_report { 'spam report' }
  end

  factory :spam_filter, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'spam_user', host: 'email.com', email: 'spammer_email@email.com', full: 'spammer <spam_user@email.com>', name: 'Spam User' }) }
    subject { 'spam email subject' }
    header {}
    body { 'Spam' }
    spam_score { '3.0' }
    spam_report { 'spam report' }
  end  

  factory :email_from_includes_numbers, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'from_user1990', host: 'email.com', email: 'from_email1990@email.com', full: 'From1990 <from_user1990@email.com>', name: '' }) }
    subject { 'email subject' }
    header {}
    body { 'Hello!' }
  end

  factory :email_forwarded, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: 'From User <from_user@email.com>', name: '' }) }
    subject { 'Fwd: email subject' }
    header {}
    raw_body { '---------- Forwarded message ---------\nFrom: Happy Forwarder <happyfwd@test.com> \nDate: Wed, Nov 7, 2018 at 5:05 AM\nSubject: Re: Test forward\nTo: to_user\n\nThis is the body here!' }
    body { '---------- Forwarded message ---------\nFrom: Happy Forwarder <happyfwd@test.com> \nDate: Wed, Nov 7, 2018 at 5:05 AM\nSubject: Re: Test forward\nTo: to_user\n\nThis is the body here!' }
  end

  factory :email_from_unknown_invalid_utf8, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: 'From User <from_user@email.com>', name: 'From User' }) }
    subject { 'email subject' }
    header {}
    body { "hi \xAD" }
  end

  factory :email_from_unknown_name_missing, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: 'from_user@email.com', name: '' }) }
    subject { 'email subject' }
    header {}
    body { 'Hello!' }
  end

  factory :email_from_known_token_numbers, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'from_user.me7731', host: 'email.com', email: 'from_user.me7731@email.com', full: 'from_user.me7731@email.com', name: '' }) }
    subject { 'email subject' }
    header {}
    body { 'Hello!' }
  end

  factory :email_to_multiple, class: OpenStruct do
    to { [{ full: 'to_user@email.com <to_user@email.com>, second_user <second_user@email.com>', email: 'to_user@email.com, second_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: 'From User <from_user@email.com>', name: 'From User' }) }
    subject { 'email subject' }
    header {}
    body { 'Hello!' }
  end

  factory :email_to_quoted, class: OpenStruct do
    to { [{ full: '"to_user@email.com" <to_user@email.com>', email: '"to_user@email.com"', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: '"From User" <from_user@email.com>', name: 'From User' }) }
    subject { 'email subject' }
    header {}
    body { 'Hello!' }
  end

  factory :email_from_unknown_with_attachments, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: 'From User <from_user@email.com>', name: 'From User' }) }
    subject { 'email subject' }
    body { 'Hello!' }
    attachments {[]}

    trait :with_attachment do
      attachments {[
        ActionDispatch::Http::UploadedFile.new({
          filename: 'logo.png',
          type: 'image/png',
          tempfile: File.new( Rails.root.join("test/fixtures/files/logo.png"))
        })
      ]}
    end

    trait :with_invalid_attachment do
      attachments {[
        ActionDispatch::Http::UploadedFile.new({
          filename: 'test.odt',
          tempfile: File.new(Rails.root.join("test/fixtures/test.odt"))
        })
      ]}
    end

    trait :with_multiple_attachments do
      attachments {[
        ActionDispatch::Http::UploadedFile.new({
          filename: 'logo.png',
          type: 'image/png',
          tempfile: File.new( Rails.root.join("test/fixtures/files/logo.png"))
        }),
        ActionDispatch::Http::UploadedFile.new({
          filename: 'logo.png',
          type: 'image/png',
          tempfile: File.new( Rails.root.join("test/fixtures/files/logo.png"))
        })
      ]}
    end
  end

  factory :email_from_known, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'scott.miller', host: 'test.com', email: 'scott.miller@test.com', full: 'Scott Miller <scott.miller@test.com>', name: 'Scott Miller' }) }
    subject { 'email subject' }
    header {}
    body { 'Hello!' }
  end

  factory :reply, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'scott.miller', host: 'test.com', email: 'scott.miller@test.com', full: 'Scott Miller <scott.miller@test.com>', name: 'Scott Miller' }) }
    subject { "Re: [Helpy Support] #1-Pending private topic" }
    header {}
    body { 'Hello!' }
  end

  factory :email_with_cc, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'scott.miller', host: 'test.com', email: 'scott.miller@test.com', full: 'Scott Miller <scott.miller@test.com>', name: 'Scott Miller' }) }
    cc { ([{ token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: 'From User <from_user@email.com>', name: 'From User' }]) }
    subject { 'email subject' }
    header {}
    body { 'Hello!' }
  end

  factory :email_with_admin_cc, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'scott.miller', host: 'test.com', email: 'scott.miller@test.com', full: 'Scott Miller <scott.miller@test.com>', name: 'Scott Miller' }) }
    cc { ([
      { token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: 'From User <from_user@email.com>', name: 'From User' },
      { token: 'support', host: 'email.com', email: 'support@mysite.com', full: 'Mysite Support <support@mysite.com>', name: 'Mysite Support' }
      ]) }
    subject { 'email subject' }
    header {}
    body { 'Hello!' }
  end

  factory :email_with_no_subject, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from { ({ token: 'scott.miller', host: 'test.com', email: 'scott.miller@test.com', full: 'Scott Miller <scott.miller@test.com>', name: 'Scott Miller' }) }
    cc { ([{ token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: 'From User <from_user@email.com>', name: 'From User' }]) }
    subject {''}
    header {}
    body { 'Hello!' }
  end

  factory :reply_to_closed_ticket, class: OpenStruct do
    to { [{ full: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com', name: nil }] }
    from{ ({ token: 'scott.miller', host: 'test.com', email: 'scott.miller@test.com', full: 'Scott Miller <scott.miller@test.com>', name: 'Scott Miller' }) }
    subject { "Re: [Helpy Support] #3-Closed private topic" }
    header {}
    body { 'Hello!' }
  end

  factory :acts_as_taggable_on_tag, class: ActsAsTaggableOn::Tag do
    name { "test_tag" }
    show_on_admin { false }
    show_on_helpcenter { false }
    show_on_dashboard { false }
  end

  factory :admin, class: User do
    name { "admin" }
    admin { true }
    role { 'admin' }
    email { 'admin@admin.com' }
    password { 'password' }
    account_number { '123456' }
  end
  
end
