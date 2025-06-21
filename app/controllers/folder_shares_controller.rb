class FolderSharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_folder, only: [:create, :index]
  before_action :ensure_ownership, only: [:create, :destroy]

  def index
    @shares = @folder.folder_shares.includes(:user)
  end

  def create
    user = User.find_by(email: params[:folder_share][:email])
    
    if user.nil?
      redirect_to share_folder_path(@folder), alert: 'User not found.'
      return
    end
    
    if user == current_user
      redirect_to share_folder_path(@folder), alert: 'You cannot share with yourself.'
      return
    end
    
    @share = @folder.folder_shares.build(
      user: user,
      shared_by: current_user,
      permission: params[:folder_share][:permission]
    )
    
    if @share.save
      redirect_to @folder, notice: "Folder shared with #{user.name}."
    else
      redirect_to share_folder_path(@folder), alert: 'Failed to share folder.'
    end
  end

  def destroy
    @share = FolderShare.find(params[:id])
    @folder = @share.folder
    
    if @share.shared_by == current_user
      @share.destroy
      redirect_to @folder, notice: 'Share removed successfully.'
    else
      redirect_to @folder, alert: 'You can only remove shares you created.'
    end
  end

  private

  def set_folder
    @folder = Folder.find(params[:folder_id])
  end

  def ensure_ownership
    unless @folder.can_edit?(current_user)
      redirect_to @folder, alert: 'You do not have permission to share this folder.'
    end
  end
end 