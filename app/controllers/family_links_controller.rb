# frozen_string_literal: true

class FamilyLinksController < ApplicationController
  def index
    @family_link = current_user.owned_family_links.first_or_create!(
      token: SecureRandom.hex(10),
      status: "pending"
    )
  end

  def accept
    @family_link = FamilyLink.find_by!(token: params[:token])
    @owner = @family_link.owner_user

    if current_user.nil?
      render :accept
    elsif true
      render :accept_l2
    else
      render :accept_l3
    end
  end
end
