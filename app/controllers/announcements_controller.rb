# frozen_string_literal: true

class AnnouncementsController < ApplicationController
  before_action :require_login

  def index
    @announcements = Announcement.published.order(published_at: :desc)
  end

  def show
    @announcement = Announcement.published.find(params.expect(:id))
  end
end
