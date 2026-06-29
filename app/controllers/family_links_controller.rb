# frozen_string_literal: true

class FamilyLinksController < ApplicationController
  before_action :require_login, except: [:accept]

  def index
    @family_link = current_user.owned_family_links
                               .where(status: 'pending')
                               .first_or_create!(
                                 token: SecureRandom.hex(10),
                                 status: 'pending'
                               )
  end

  def accept
    @family_link = FamilyLink.find_by!(token: params[:token])
    @owner = @family_link.owner_user

    if current_user.nil?
      session[:return_to_after_login] = invite_path(@family_link.token)
      render :accept

    elsif @family_link.owner_user == current_user
      redirect_to root_path,
                  alert: '自分自身は招待できません'

    elsif @family_link.member_user == current_user && @family_link.status == 'accepted'
      redirect_to root_path, notice: 'すでに家族共有されています'

    elsif !current_user.line_bot_connected?
      render :accept_l2

    else
      @family_link.update!(
        member_user: current_user,
        status: 'accepted'
      )

      render :accept_l3
    end
  end

  def destroy
    family_link = current_user.owned_family_links.find(params[:id])

    family_link.destroy

    redirect_to family_links_path, notice: '家族共有を解除しました'
  end
end
