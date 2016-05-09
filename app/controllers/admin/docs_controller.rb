class Admin::DocsController < Admin::BaseController

  def new
    @doc = Doc.new
    @doc.category_id = params[:category_id]

    @post = Post.where(id: params[:post_id]).first if current_user.admin == true
    @categories = Category.alpha

    respond_to do |format|
      format.html
    end
  end

  def edit
    @doc = Doc.find(params[:id])
    @category = Category.where(id: params[:category_id]).first
    @categories = Category.alpha
  end

  def create
    @doc = Doc.new(doc_params)
    @doc.user_id = current_user.id

    respond_to do |format|
      if @doc.save
        #@doc.tag_list = params[:tags]
        #@doc.save
        format.html { redirect_to(admin_category_path(@doc.category.id)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    unless params['lang'].nil?
      I18n.locale = params['lang']
    end
    @doc = Doc.where(id: params[:id]).first

    respond_to do |format|
      if @doc.update_attributes(doc_params)
        format.html { redirect_to(admin_category_path(@doc.category.id)) }
      else
        format.html { render :action => "edit", :id => @doc }
      end
    end
  end

  def destroy
    @doc = Doc.find(params[:id])
    @doc.destroy

    respond_to do |format|
      format.js { render js:"$('#doc-#{@doc.id}').fadeOut();
      Helpy.ready();
      Helpy.track();" }
    end
  end

  private

  def doc_params
    params.require(:doc).permit(
    :title,
    :body,
    :keywords,
    :title_tag,
    :meta_description,
    :category_id,
    :rank,
    :active,
    :front_page,
    :user_id,
    :allow_comments,
    {screenshots: []}
  )
  end

end
