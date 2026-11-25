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

    @read_announcement_ids = current_user.announcement_reads
                                         .where(announcement_id: @announcements.map(&:id))
                                         .pluck(:announcement_id)
                                         .to_set
  end

  def show
    @announcement =
      if current_user.admin?
        Announcement.find(params.expect(:id))
      else
        Announcement.published.find(params.expect(:id))
      end

    mark_as_read(@announcement)
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

  # 詳細ページを開いたときだけ既読にする（下書き・公開予約のプレビューは対象外）
  def mark_as_read(announcement)
    return unless announcement.published?

    # すでに既読なら何もしない。同時に2回リクエストが来ても、一意制約にぶつかった方は無視される
    AnnouncementRead.insert( # rubocop:disable Rails/SkipsModelValidations
      { user_id: current_user.id, announcement_id: announcement.id },
      unique_by: %i[user_id announcement_id]
    )
  end

  def set_announcement
    @announcement = Announcement.find(params.expect(:id))
  end

  def announcement_params
    params.expect(announcement: %i[title body category published_at])
  end
end
