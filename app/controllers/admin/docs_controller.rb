class Admin::DocsController < Admin::BaseController

  before_action :verify_editor
  respond_to :html, only: ['new','edit','create']
  respond_to :js, only: ['destroy']

  def new
    @doc = Doc.new
    @doc.category_id = params[:category_id]
    @doc.body = Post.where(id: params[:post_id]).first.body if params[:post_id]
    @categories = Category.alpha
  end

  def edit
    @doc = Doc.find(params[:id])
    @category = Category.where(id: params[:category_id]).first
    @categories = Category.alpha
  end

  def create
    @doc = Doc.new(doc_params)
    @doc.user_id = current_user.id
    if @doc.save
      redirect_to(admin_category_path(@doc.category.id))
    else
      render 'new'
    end
  end

  def update
    unless params['lang'].nil?
      I18n.locale = params['lang']
    end
    @doc = Doc.where(id: params[:id]).first
    @category = @doc.category
    # @doc.tag_list = params[:doc][:tag_list]
    if @doc.update_attributes(doc_params)
      respond_to do |format|
        format.html {
          redirect_to(admin_category_path(@category.id))
        }
        format.js {
        }
      end
    else
      respond_to do |format|
        format.html {
          render 'edit', id: @doc
        }
      end
    end

  end

  def destroy
    @doc = Doc.find(params[:id])
    @doc.destroy
    render js:"
      $('#doc-#{@doc.id}').fadeOut();
      Helpy.ready();
      Helpy.track();"
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
    :allow_comments,
    {screenshots: []},
    :tag_list
  )
  end

end
