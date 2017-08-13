class CreateProductTypeService
  def call
    categories = []
    category = Category.create!(name: 'TRONCAL') #create and assign admin category
    ap "CATEGORY: #{category.inspect}"
    categories << category
    category = Category.create!(name: 'RDA') #create and assign editor category
    ap "CATEGORY: #{category.inspect}"
    categories << category
    category = Category.create!(name: 'FTTH') #cerate and assign user category
    ap "CATEGORY: #{category.inspect}"
    categories << category
  end
end