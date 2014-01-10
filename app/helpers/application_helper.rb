module ApplicationHelper
	def javascript(*files)
	  content_for(:head) { javascript_include_tag(*files) }
	end

	def stylesheet(*files)
	  content_for(:head) { stylesheet_link_tag(*files) }
	end

  def class_for_current_path(path)
    'active' if current_page?(path)
  end

  def menu_item_to(name=nil, args)
    path = url_for args
    content_tag :li, :class => class_for_current_path(path) do
      link_to name, path
    end
  end

  def link_item_to(name=nil, args, attributes)
    path = url_for args    
    link_to name, path, attributes
  end

  def all_years
    @years ||= []
    if @years.size > 1
      years = " с #{@years.first} по #{@years.last}"
    elsif @years.size == 1
      years = " в #{@years.first}"
    end 
    years ||= ''
  end
end
