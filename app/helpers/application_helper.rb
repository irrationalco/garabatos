module ApplicationHelper
  def sidebar_link icon, text, link=nil, **options
    content_tag :li, options do
      link_to(link || 'javascript:void(0)') do
        fa_icon(icon, class: 'fa-fw') + content_tag(:p, text)
      end
    end
  end

  def chart_panel title, subtitle=nil, &block
    content_tag :div, class: ['panel', 'chart-panel'] do
      concat (content_tag :div, class: 'panel-heading' do
        concat (content_tag :h3, title, class: 'panel-title')
        if subtitle
          concat(content_tag :p, subtitle)
        end
      end)
      concat(capture(&block))
    end
  end

  def panel title, subtitle=nil, &block
    content_tag :div, class: 'panel' do
      concat (content_tag :div, class: 'panel-heading' do
        concat (content_tag :h3, title, class: 'panel-title')
        if subtitle
          concat(content_tag :p, subtitle)
        end
      end)
      concat(capture(&block))
    end
  end
end