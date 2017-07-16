module ApplicationHelper
  def sidebar_link icon, text, link=nil, **options
    content_tag :li, options do
      link_to(link ? link : 'javascript:void(0)') do
        fa_icon(icon, class: 'fa-fw') + content_tag(:p, text)
      end
    end
  end
end