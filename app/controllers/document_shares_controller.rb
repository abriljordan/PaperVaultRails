class DocumentSharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: [:create, :index]
  before_action :ensure_ownership, only: [:create, :destroy]

  def index
    @shares = @document.document_shares.includes(:user)
  end

  def create
    user = User.find_by(email: params[:document_share][:email])
    
    if user.nil?
      redirect_to share_document_path(@document), alert: 'User not found.'
      return
    end
    
    if user == current_user
      redirect_to share_document_path(@document), alert: 'You cannot share with yourself.'
      return
    end
    
    @share = @document.document_shares.build(
      user: user,
      shared_by: current_user,
      permission: params[:document_share][:permission]
    )
    
    if @share.save
      redirect_to @document, notice: "Document shared with #{user.name}."
    else
      redirect_to share_document_path(@document), alert: 'Failed to share document.'
    end
  end

  def destroy
    @share = DocumentShare.find(params[:id])
    @document = @share.document
    
    if @share.shared_by == current_user
      @share.destroy
      redirect_to @document, notice: 'Share removed successfully.'
    else
      redirect_to @document, alert: 'You can only remove shares you created.'
    end
  end

  private

  def set_document
    @document = Document.find(params[:document_id])
  end

  def ensure_ownership
    unless @document.can_edit?(current_user)
      redirect_to @document, alert: 'You do not have permission to share this document.'
    end
  end
end 