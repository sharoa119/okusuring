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

    elsif @family_link.owner_user == current_user
      redirect_to root_path,
                  alert: "自分自身は招待できません"

    elsif true # BOT未追加（未実装
      render :accept_l2

    else
      @family_link.update!(
        member_user: current_user,
        status: "accepted"
      )

      render :accept_l3
    end
  end
end
