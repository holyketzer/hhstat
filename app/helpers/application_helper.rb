module ApplicationHelper
	def javascript(*files)
	  content_for(:head) { javascript_include_tag(*files) }
	end

	def stylesheet(*files)
	  content_for(:head) { stylesheet_link_tag(*files) }
	end

  def menu_item_to(name=nil, args)
    path = url_for args
    content_tag :li, :class => is_active?(path) do
      link_to name, path
    end
  end
end
