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
end
