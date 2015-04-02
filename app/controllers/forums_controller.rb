class ForumsController < ApplicationController
  #cache_sweeper :forum_sweeper, :only => [:update, :create, :destroy]
  add_breadcrumb 'Home', :root_path

  # GET /forums
  # GET /forums.xml
  def index
    @forums = Forum.order('name ASC')
    @meta_title = "Forums"
    @private_topics = current_user.topics.isprivate if user_signed_in?

    @page_title = "Community"
    add_breadcrumb 'Community'
    @title_tag = "#{Settings.site_name} Support: Community"
    @meta_desc = "Community discussion for #{Settings.site_name}"
    @keywords = "support, articles, documentation, how-to, faq, frequently asked questions, forum, discussion"

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @forums.to_xml }
    end
  end

  # GET /forums/1
  # GET /forums/1.xml
  def show
    redirect_to topics_path(:forum_id => params[:id])
  end

  # GET /forums/new
  def new
    @forum = Forum.new
  end

  # GET /forums/1;edit
  def edit
    @forum = Forum.find(params[:id])
  end

  # POST /forums
  # POST /forums.xml
  def create
    @forum = Forum.new(params[:forum])

    respond_to do |format|
      if @forum.save
        flash[:notice] = 'Forum was successfully created.'
        format.html { redirect_to forums_path }
        format.xml  { head :created, :location => forum_url(@forum) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum.errors.to_xml }
      end
    end
  end

  # PUT /forums/1
  # PUT /forums/1.xml
  def update
    @forum = Forum.find(params[:id])

    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        flash[:notice] = 'Forum was successfully updated.'
        format.html { redirect_to forum_url(@forum) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum.errors.to_xml }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.xml
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to forums_url }
      format.xml  { head :ok }
    end
  end
end
