module PaginationHelper
  
  def paginate(collection)
    @collection = collection
    @current_page = @collection.current_page
    @prev_page = @current_page - 1
    @next_page = @current_page + 1
    @last_page = @collection.total_pages
    
    ul_pagination
  end
  
  def ul_pagination
    content_tag(:ul, class: :pagination) do
      concat go_first_page.to_s
      concat go_prev_page.to_s
      concat go_two_prev_current.to_s
      concat go_one_prev_current.to_s
      concat current_page.to_s
      concat go_one_next.to_s
      concat go_two_next.to_s
      concat go_next_page.to_s
      concat go_last_page.to_s
    end
  end
  
  def go_first_page
    unless @collection.first_page?
      page = {page: 1}
      content_tag(:li) do
        link_to "<<", url_for(params.merge(page))
      end
    end
  end
  
  def go_prev_page
    unless @collection.first_page?
      page = {page: @prev_page}
      return content_tag(:li) do
        link_to "<", url_for(params.merge(page))
      end
    end
  end
  
  def go_two_prev_current
   if @current_page > 2
      page = {page: @current_page - 2}
      content_tag(:li) do
        link_to @current_page - 2, url_for(params.merge(page))
      end
    end
  end
  
  def go_one_prev_current
    if @current_page > 1
      page = {page: @current_page - 1}
      content_tag(:li) do
        link_to @current_page - 1, url_for(params.merge(page))
      end
    end
  end
  
  def current_page
    content_tag(:li, class: :disabled) do
      link_to @current_page, url_for(params)
    end
  end
  
  def go_one_next
    if (@current_page + 1) < @last_page
      page = {page: @current_page + 1}
      content_tag(:li) do
        link_to @current_page + 1, url_for(params.merge(page))
      end
    end
  end
  
  def go_two_next
    if (@current_page + 2) < @last_page
      page = {page: @current_page + 2}
      content_tag(:li) do
        link_to @current_page + 2, url_for(params.merge(page))
      end
    end
  end
  
  def go_next_page
    unless @contacts.last_page?
      page = {page: @next_page}
      return content_tag(:li) do
        link_to ">", url_for(params.merge(page))
      end
    end
  end
  
  def go_last_page
    unless @contacts.last_page?
      page = {page: @last_page}
      return content_tag(:li) do
        link_to ">>", url_for(params.merge(page))
      end
    end
  end
end

