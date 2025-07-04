class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_folder, only: [:show, :edit, :update, :destroy, :star, :unstar, :share, :dropdown]
  before_action :ensure_access, only: [:show, :edit, :update, :destroy]
  before_action :ensure_ownership, only: [:edit, :update, :destroy, :share]

  def index
    @folders = current_user.folders.root_folders.order(:name)
    @shared_folders = Folder.shared_with(current_user)
  end

  def show
    @subfolders = @folder.children.order(:name)
    @documents = @folder.documents.order(:name)
    @breadcrumbs = get_breadcrumbs(@folder)
  end

  def new
    @folder = current_user.folders.build
    @parent_folder = Folder.find(params[:parent_id]) if params[:parent_id]
  end

  def create
    @folder = current_user.folders.build(folder_params)
    
    if @folder.save
      Rails.logger.info "Folder created successfully: #{@folder.id} - #{@folder.name}"
      redirect_to @folder, notice: 'Folder created successfully.'
    else
      Rails.logger.error "Folder creation failed: #{@folder.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @folder.update(folder_params)
      redirect_to @folder, notice: 'Folder updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    parent = @folder.parent
    @folder.destroy
    
    respond_to do |format|
      format.html { redirect_to parent || folders_path, notice: 'Folder deleted successfully.' }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@folder) }
      format.json { head :no_content }
    end
  end

  def star
    @folder.update(is_starred: true, starred_at: Time.current)
    redirect_back(fallback_location: folders_path, notice: 'Folder starred successfully.')
  end

  def unstar
    @folder.update(is_starred: false, starred_at: nil)
    redirect_back(fallback_location: folders_path, notice: 'Folder unstarred successfully.')
  end

  def share
    @share = @folder.folder_shares.build
  end

  def dropdown
    respond_to do |format|
      format.html { 
        render partial: "folders/dropdown", locals: { folder: @folder }
      }
      format.turbo_stream { 
        render turbo_stream: turbo_stream.update(
          "folder_#{@folder.id}_dropdown",
          partial: "folders/dropdown", locals: { folder: @folder }
        )
      }
    end
  end

  private

  def set_folder
    @folder = Folder.find(params[:id])
  end

  def folder_params
    params.require(:folder).permit(:name, :parent_id, :color)
  end

  def ensure_access
    unless @folder.can_access?(current_user)
      redirect_to root_path, alert: 'You do not have access to this folder.'
    end
  end

  def ensure_ownership
    unless @folder.can_edit?(current_user)
      redirect_to @folder, alert: 'You do not have permission to modify this folder.'
    end
  end

  def get_breadcrumbs(folder)
    breadcrumbs = []
    current = folder
    
    while current
      breadcrumbs.unshift(current)
      current = current.parent
    end
    
    breadcrumbs
  end
end 