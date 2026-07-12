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
