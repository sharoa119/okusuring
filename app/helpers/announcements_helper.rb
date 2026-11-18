# frozen_string_literal: true

module AnnouncementsHelper
  def announcement_category_class(category)
    case category
    when '新機能'
      'announcement-category--new'
    when '改善・修正'
      'announcement-category--improvement'
    else
      'announcement-category--other'
    end
  end

  def announcement_status_label(announcement)
    if announcement.published_at.nil?
      '下書き'
    elsif announcement.published_at.future?
      '公開予約'
    else
      '公開済み'
    end
  end

  def announcement_body_with_links(body)
    formatted_body = simple_format(body)

    linked_body = formatted_body.gsub(%r{https?://[^\s<]+}) do |url|
      link_to(url, url, target: '_blank', rel: 'noopener noreferrer')
    end

    sanitize(linked_body, tags: %w[p br a], attributes: %w[href target rel])
  end
end
