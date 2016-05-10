class Admin::SharedController < Admin::BaseController

  def update_order
    # Safely identify the model we're updating the position of
    klass = [Category, Doc].detect { |c| c.name.casecmp(params[:object]) == 0 }
    @obj = klass.find(params[:obj_id])
    @obj.rank_position = params[:row_order_position]
    @obj.save!

    render nothing: true
  end

end
