ActiveAdmin::Views::PaginatedCollection.class_eval do
  def build_pagination_with_formats(options)
    div :id => 'index_footer' do
      build_pagination
      div(page_entries_info(options).html_safe, class: 'pagination_information')
      build_download_format_links([:csv, :json]) unless !@download_links
    end
  end
end