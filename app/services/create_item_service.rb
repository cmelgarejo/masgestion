class CreateItemService
  def call(company_id, label, extra_properties = nil, is_template = false, template = nil, parents = [], categories = [])
    ap "TEMPLATE: #{template.id} - #{template.label}" if template
    extra_properties = template.extra_properties if !is_template && template && template.is_template
    item = Item.find_or_create_by!(company: Company.find_by_id(company_id), label: label, description: label)
    #ap "#{item.inspect}"
    item.extra_properties = extra_properties
    item.parents << parents
    item.categories << categories
    item.save!
    ap "Created Item: #{item.id} - #{item.label}"
    item #return Item
  end
end