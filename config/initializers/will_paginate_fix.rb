class CustomLinkRenderer < WillPaginate::ActionView::LinkRenderer
  def url(page)
    @base_url_params ||= begin
      url_params = merge_get_params(default_url_params)
      url_params[:only_path] = true
      merge_optional_params(url_params)
    end

    url_params = @base_url_params.dup
    add_current_page_param(url_params, page)

    if @options[:url_scope]
      @options[:url_scope].url_for(url_params)
    else
      @template.url_for(url_params)
    end
  end
end
