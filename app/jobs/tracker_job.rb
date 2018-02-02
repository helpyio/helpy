class TrackerJob < ApplicationJob
  queue_as :default

  def perform(category, action, label, value, client_id, ga_id)
    if ga_id.present?
      # Initiate the tracker
      instantiate_tracker(client_id, ga_id)

      # Send the actual event data to Google
      @tracker.event(category: category, action: action, label: label, value: value)
    end
  end

  def instantiate_tracker(client_id, ga_id)
    # instantiate a tracker instance for GA Measurement Protocol
    # this is used to track events happening on the server side, like email support ticket creation

    # Here we will use the client_id if it is available, if not we send in an
    # anonymous google event.  Anonymous events do artifically inflate visitor
    # numbers since they are not linked to a specific client_id

    if client_id.present?
      logger.info("initiate tracker with client id")
      @tracker = Staccato.tracker(ga_id, client_id)
    else
      logger.info("!!! initiate tracker without client id !!!")
      @tracker = Staccato.tracker(ga_id)
    end
  end


end
