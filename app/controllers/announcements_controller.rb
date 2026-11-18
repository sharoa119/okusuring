# frozen_string_literal: true

class AnnouncementsController < ApplicationController
  before_action :require_login
  before_action :require_admin, except: %i[index show]
  before_action :set_announcement, only: %i[edit update destroy]

  def index
    @announcements =
      if current_user.admin?
        Announcement.order(created_at: :desc)
      else
        Announcement.published.order(published_at: :desc)
      end
  end

  def show
    @announcement =
      if current_user.admin?
        Announcement.find(params.expect(:id))
      else
        Announcement.published.find(params.expect(:id))
      end
  end

  def new
    @announcement = Announcement.new
  end

  def edit; end

  def create
    @announcement = Announcement.new(announcement_params)

    if @announcement.save
      redirect_to announcements_path, notice: 'お知らせを登録しました'
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @announcement.update(announcement_params)
      redirect_to announcement_path(@announcement), notice: 'お知らせを更新しました'
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @announcement.destroy
    redirect_to announcements_path, notice: 'お知らせを削除しました'
  end

  private

  def set_announcement
    @announcement = Announcement.find(params.expect(:id))
  end

  def announcement_params
    params.expect(announcement: %i[title body category published_at])
  end
end
