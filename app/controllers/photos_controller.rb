class PhotosController < ApplicationController
  before_action :set_photo, only: [:addtag, :chtag, :show, :edit, :update, :destroy]

  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.order(created_at: :desc).page params[:page]
    @tags = Tag.all
  end

  def untag
    @photos = Photo.where.not(id: PhotosTag.select('photo_id')).order(created_at: :desc).page params[:page]
    render 'index'
  end

  def chtag
    tag_content = params[:tag_content].strip.downcase
    @photo.tags.destroy Tag.find(params[:tag_id])
    tag = Tag.where(content: tag_content).first
    tag = Tag.create(content: tag_content) if tag.blank?
    @photo.tags << tag
    @tags = Tag.all
    @active = params[:active]
    respond_to do |format|
      format.js
    end
  end

  def addtag
    tag = Tag.find(params[:tag_id])
    @photo.tags << tag unless @photo.tags.include?(tag)
    respond_to do |format|
      format.js
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)
    render plain: @photo.save
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:title, :picture)
    end
  end
