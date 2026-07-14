# frozen_string_literal: true

module ApplicationHelper
  # 服薬の「済/未」バッジ。環境依存の絵文字ではなく、全環境で同じ見た目になる
  # インラインSVG（Material Symbols 風の丸みのあるアイコン）で表示する。
  def medication_status_badge(taken)
    if taken
      tag.span(class: 'med-status done') do
        safe_join([check_circle_icon, tag.span('済')])
      end
    else
      tag.span(class: 'med-status pending') do
        safe_join([circle_outline_icon, tag.span('未')])
      end
    end
  end

  def invite_link_icon
    tag.svg(class: 'invite-link-icon', viewBox: '0 0 24 24', width: 20, height: 20,
            fill: 'none', stroke: 'currentColor', 'stroke-linecap': 'round',
            'stroke-linejoin': 'round', 'stroke-width': 2, 'aria-hidden': 'true') do
      safe_join([
        tag.path(d: 'M10.59 13.41a1.996 1.996 0 010-2.82l3.18-3.18a2 2 0 112.83 2.83l-1.06 1.06'),
        tag.path(d: 'M13.41 10.59a1.996 1.996 0 010 2.82l-3.18 3.18a2 2 0 11-2.83-2.83l1.06-1.06')
      ])
    end
  end

  def family_linked_icon
    tag.svg(class: 'family-status-icon', viewBox: '0 0 24 24', width: 14, height: 14,
            fill: 'currentColor', 'aria-hidden': 'true') do
      tag.path(d: 'M12 2a10 10 0 100 20 10 10 0 000-20zm-1.3 14.3L6.4 12l1.4-1.4 3 3 5.4-5.4 1.4 1.4-6.8 6.7z')
    end
  end

  def remove_icon
    tag.svg(class: 'family-action-icon', viewBox: '0 0 24 24', width: 14, height: 14,
            fill: 'none', stroke: 'currentColor', 'stroke-linecap': 'round',
            'stroke-linejoin': 'round', 'stroke-width': 2, 'aria-hidden': 'true') do
      safe_join([
        tag.path(d: 'M18 6L6 18'),
        tag.path(d: 'M6 6l12 12')
      ])
    end
  end

  private

  def check_circle_icon
    tag.svg(class: 'status-icon', viewBox: '0 0 24 24', width: 18, height: 18,
            fill: 'currentColor', 'aria-hidden': 'true') do
      tag.path(d: 'M12 2a10 10 0 100 20 10 10 0 000-20zm-1.3 14.3L6.4 12l1.4-1.4 3 3 5.4-5.4 1.4 1.4-6.8 6.7z')
    end
  end

  def circle_outline_icon
    tag.svg(class: 'status-icon', viewBox: '0 0 24 24', width: 18, height: 18,
            fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'aria-hidden': 'true') do
      tag.circle(cx: 12, cy: 12, r: 9)
    end
  end
end
