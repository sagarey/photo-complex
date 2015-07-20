class PhotosController < ApplicationController
  before_action :set_photo, only: [:addtag, :chtag, :show, :edit, :update, :destroy]

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

  def show
  end

  def new
    @photo = Photo.new
  end

  def edit
  end

  def create
    @photo = Photo.new(photo_params)
    render plain: @photo.save
  end

  def update
    if @photo.update(photo_params)
      redirect_to @photo, notice: 'Photo was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @photo.destroy
    tag = params[:active].split('_').last
    if tag == 'untag'
      @photos = Photo.where.not(id: PhotosTag.select('photo_id')).order(created_at: :desc).page params[:page]
    elsif tag == 'all'
      @photos = Photo.order(created_at: :desc).page params[:page]
    else
      @photos = Tag.where(content: tag).first.photos.order(created_at: :desc).page params[:page]
    end
    respond_to do |format|
      format.js { render :index }
    end
  end

  private
    def set_photo
      @photo = Photo.find(params[:id])
    end

    def photo_params
      params.require(:photo).permit(:title, :picture)
    end
end
