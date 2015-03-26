class DocsController < ApplicationController

  before_filter :authenticate!, :except => ['show', 'home']
  #before_filter :authenticate_master?, :except => 'show'
  before_filter :get_tags
  #before_filter :set_docs, :only => 'show'
  after_filter :view_causes_vote, :only => 'show'

  # GET /docs.xml
  def index
    @docs = Doc.by_category

    respond_to do |format|
      format.html { render :layout => 'admin' }

    end
  end

  # GET /docs/1
  # GET /docs/1.xml
  def show
    @doc = Doc.find(params[:id])


    respond_to do |format|
      format.html # show.html.erb

    end
  end

  # GET /docs/new
  # GET /docs/new.xml
  def new
    @doc = Doc.new
    @categories = Category.alpha

    respond_to do |format|
      format.html { render :layout => 'admin' }

    end
  end

  # GET /docs/1/edit
  def edit
    @doc = Doc.find(params[:id])
    @categories = Category.alpha

    render :layout => 'admin'
  end

  # POST /docs
  # POST /docs.xml
  def create
    @doc = Doc.new(params[:doc])

    respond_to do |format|
      if @doc.save

        @doc.tag_list = params[:tags]
        @doc.save
        flash[:notice] = 'Doc was successfully created.'
        format.html { redirect_to(docs_path) }

      else
        format.html { render :action => "new" }

      end
    end
  end

  # PUT /docs/1
  # PUT /docs/1.xml
  def update
    @doc = Doc.find(params[:id])

    respond_to do |format|
      if @doc.update_attributes(params[:doc])

        @doc.tag_list = params[:tags]
        @doc.save
        flash[:notice] = 'Doc was successfully updated.'
        format.html { redirect_to(docs_path) }

      else
        format.html { render :action => "edit" }

      end
    end
  end

  # DELETE /docs/1
  # DELETE /docs/1.xml
  def destroy
    @doc = Doc.find(params[:id])
    @doc.destroy

    respond_to do |format|
      format.html { redirect_to(docs_url) }

    end
  end

  def set_docs
    if params[:permalink]
      @doc = Doc.find_by_permalink(params[:permalink])
    else
      category = Category.find_by_link(params[:link])
      @doc = Doc.find_by_category_id(params[:link])
    end
    @related = Doc.in_category(@doc.category_id)
  end

  def home
    render(:layout => 'discussion')
  end

  protected


  def get_tags
    @tags = Doc.tag_counts
  end

  def view_causes_vote
    if user_signed_in?
      @doc.votes.create unless current_user.admin?
    else
      @doc.votes.create
    end
  end

end
