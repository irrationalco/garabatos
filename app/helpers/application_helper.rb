module ApplicationHelper
  def sidebar_link icon, text, link, options=nil
    content_tag :li, options do
      link_to(link ? link : 'javascript:void(0)') do
        fa_icon(icon) + content_tag(:p, text)
      end
    end
  end
end