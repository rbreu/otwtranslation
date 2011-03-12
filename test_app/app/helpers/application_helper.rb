module ApplicationHelper

  def link_to_remote(name, options = {}, html_options = {})
    unless html_options[:href]
      html_options[:href] = url_for(options[:url])
    end
    
    link_to_function(name, remote_function(options), html_options)
  end

  def span_if_current(link_to_default_text, path)
    translation_name = "layout.header." + link_to_default_text.gsub(/\s+/, "_")
    link = link_to_unless_current(h(t(translation_name, :default => link_to_default_text)), path)
    current_page?(path) ? "<span class=\"current\">#{link}</span>".html_safe : link
  end
  
  def classes_for_main
    class_names = controller.controller_name + '-' + controller.action_name
    show_sidebar = ((@user || @admin_posts || @collection) && !@hide_dashboard)
    class_names += " sidebar" if show_sidebar
    class_names
  end

  def flash_div *keys
    keys.collect { |key| 
      if flash[key] 
        content_tag(:div, h(flash[key]), :class => "flash #{key}") if flash[key] 
      end
    }.join.html_safe
  end

end
