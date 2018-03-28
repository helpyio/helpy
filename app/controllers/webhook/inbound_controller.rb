class Webhook::InboundController < Webhook::BaseController

  # We skip auth token for incoming webhooks
  skip_before_action :verify_authenticity_token
  before_action(only: [:form]) { enabled?('form') }
  before_action(only: [:form]) { check_token(AppSettings['webhook.form_key']) }

  # Accept a json object from a POST operation directly to your form webhook URL
  # This will attempt to recognize the user via their email address and will
  # attach the message to that user if found. Otherwise it will create a new user
  # record.

  # data = {
  #     "message": {
  #         "kind": "ticket",
  #         "subject": "Need Help",
  #         "body": "Hi there. Need any help?",
  #         "channel": "web"
  #     },
  #     "customer": {
  #         "fullName": "Bob Doe",
  #         "emailAddress": "bob@example.com",
  #         "work_phone": "(555) 555-5555",
  #         "home_phone": "(555) 555-5555",
  #         "city": "Palo Alto",
  #         "region": "CA",
  #         "country": "United States",
  #         "countryCode": "US",
  #         "company": "Widgets Inc."
  #     }
  # }

  # You can test this out on your serer with the following curl
  # curl -X POST http://helpy.local:3000/webhook/form/50be1e6071ee4e4727f5977689598ca0 --data-urlencode 'data={"message": {"kind": "ticket","subject": "Need Help","body": "Hi there. I need help.","channel": "web","team":"tier 1", "tags":"hello, hi"},"customer": {"fullName": "Bob Doe","emailAddress": "bob@example.com","work_phone": "(555) 555-5555","home_phone": "(555) 555-5555","city": "Palo Alto","region": "CA","country": "United States","countryCode": "US","company": "Widgets Inc."}}'

  def form
    @params = JSON.parse(request.params[:data])

    # create topic and first post
    @topic = Topic.new(
      name: @params['message']['subject'],
      forum_id: 1,
      private: true,
      channel: @params['message']['channel'],
      team_list: @params['message']['team'],
      tag_list: @params['message']['tags'],
      priority: @params['message']['priority']
      )
      
    if @topic.create_topic_with_webhook_user(@params)
      @user = @topic.user
      @post = @topic.posts.create(
        body: @params['message']['body'],
        user_id: @user.id,
        kind: 'first',
        )
    end

    render json: @topic
  end


end
