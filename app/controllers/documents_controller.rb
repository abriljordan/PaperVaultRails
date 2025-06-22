class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: [:show, :edit, :update, :destroy, :download, :star, :unstar, :share, :dropdown]
  before_action :ensure_access, only: [:show, :download]
  before_action :ensure_ownership, only: [:edit, :update, :destroy, :share]

  def index
    @documents = current_user.documents.order(:name)
    @shared_documents = Document.shared_with(current_user)
  end

  def show
    @document.update(last_accessed_at: Time.current, access_count: @document.access_count + 1)
  end

  def new
    @document = current_user.documents.build
    @folder = Folder.find(params[:folder_id]) if params[:folder_id]
  end

  def create
    @document = current_user.documents.build(document_params)
    
    if @document.save
      redirect_to @document, notice: 'Document uploaded successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @document.update(document_params)
      redirect_to @document, notice: 'Document updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    redirect_to documents_path, notice: 'Document deleted successfully.'
  end

  def download
    if @document.file.attached?
      @document.update(last_accessed_at: Time.current, access_count: @document.access_count + 1)
      redirect_to rails_blob_path(@document.file, disposition: 'attachment')
    else
      redirect_to @document, alert: 'File not found.'
    end
  end

  def star
    @document.update(is_starred: true, starred_at: Time.current)
    respond_to do |format|
      format.html { redirect_back(fallback_location: @document) }
      format.json { render json: { starred: true, message: "Document starred successfully" } }
      format.turbo_stream { 
        render turbo_stream: turbo_stream.replace(
          "document_#{@document.id}",
          partial: "documents/document", locals: { document: @document }
        )
      }
    end
  end

  def unstar
    @document.update(is_starred: false, starred_at: nil)
    respond_to do |format|
      format.html { redirect_back(fallback_location: @document) }
      format.json { render json: { starred: false, message: "Document unstarred successfully" } }
      format.turbo_stream { 
        render turbo_stream: turbo_stream.replace(
          "document_#{@document.id}",
          partial: "documents/document", locals: { document: @document }
        )
      }
    end
  end

  def share
    @share = @document.document_shares.build
  end

  def dropdown
    respond_to do |format|
      format.html { 
        render partial: "documents/dropdown", locals: { document: @document }
      }
      format.turbo_stream { 
        render turbo_stream: turbo_stream.update(
          "document_#{@document.id}_dropdown",
          partial: "documents/dropdown", locals: { document: @document }
        )
      }
    end
  end

  def bulk_upload
    @folder = Folder.find(params[:folder_id]) if params[:folder_id]
  end

  def process_bulk_upload
    folder = Folder.find(params[:folder_id]) if params[:folder_id]
    uploaded_files = params[:files]
    
    if uploaded_files
      uploaded_files.each do |file|
        document = current_user.documents.build(
          name: file.original_filename,
          folder: folder
        )
        document.file.attach(file)
        document.save
      end
      
      redirect_to folder || documents_path, notice: 'Files uploaded successfully.'
    else
      redirect_to bulk_upload_documents_path, alert: 'No files selected.'
    end
  end

  def debug
    @document = current_user.documents.build
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :folder_id, :file)
  end

  def ensure_access
    unless @document.can_access?(current_user)
      redirect_to root_path, alert: 'You do not have access to this document.'
    end
  end

  def ensure_ownership
    unless @document.can_edit?(current_user)
      redirect_to @document, alert: 'You do not have permission to modify this document.'
    end
  end
end 