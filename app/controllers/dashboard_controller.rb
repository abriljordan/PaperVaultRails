class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @folders = current_user.folders.root_folders.order(:name)
    @documents = current_user.documents.where(folder: nil).recent.limit(20)
    @shared_folders = Folder.shared_with(current_user).limit(10)
    @shared_documents = Document.shared_with(current_user).limit(10)
    @recent_documents = current_user.documents.recent.limit(10)
    @starred_items = get_starred_items
    @storage_usage = {
      used: current_user.total_storage_used,
      limit: current_user.storage_limit,
      percentage: (current_user.total_storage_used.to_f / current_user.storage_limit * 100).round(1)
    }
  end

  def search
    @query = params[:q]
    @results = []
    
    if @query.present?
      @results = search_items(@query)
    end
    
    respond_to do |format|
      format.html { render :search }
      format.json { render json: @results }
    end
  end

  def shared
  end

  def starred
    @starred_items = get_starred_items
  end

  def trash
  end

  private

  def get_starred_items
    starred_folders = current_user.folders.where(is_starred: true).order(:starred_at)
    starred_documents = current_user.documents.where(is_starred: true).order(:starred_at)
    
    (starred_folders + starred_documents).sort_by(&:starred_at).reverse
  end

  def search_items(query)
    results = []
    
    # Search in user's own items
    folders = current_user.folders.where("name ILIKE ?", "%#{query}%")
    documents = current_user.documents.where("name ILIKE ?", "%#{query}%")
    
    # Search in shared items
    shared_folders = Folder.shared_with(current_user).where("name ILIKE ?", "%#{query}%")
    shared_documents = Document.shared_with(current_user).where("name ILIKE ?", "%#{query}%")
    
    results.concat(folders.map { |f| { type: 'folder', item: f, owner: f.user } })
    results.concat(documents.map { |d| { type: 'document', item: d, owner: d.user } })
    results.concat(shared_folders.map { |f| { type: 'shared_folder', item: f, owner: f.user } })
    results.concat(shared_documents.map { |d| { type: 'shared_document', item: d, owner: d.user } })
    
    results
  end
end 