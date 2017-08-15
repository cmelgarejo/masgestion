class CreateDocumentTypesService
  def call
    DocumentType.create!(description: 'CI')
    DocumentType.create!(description: 'RUC')
    DocumentType.create!(description: 'Pasaporte')
  end
end