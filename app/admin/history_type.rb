ActiveAdmin.register HistoryType do
  permit_params :description #, :active
  actions :all, except: [:show]
  menu parent: I18n.t('Configuration'), priority: 2, label: I18n.t('History_Type')

  index title: I18n.t('History_Type') do
    column I18n.t('Description') do |resource|
      link_to resource.name, edit_admin_history_type_path(resource)
    end
    #bool_column I18n.t('Active'), :active
    column I18n.t('Created_at'), :created_at
    column I18n.t('Updated_at'), :updated_at
    actions
  end

  filter :description
  #filter :active
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.actions do
      f.action :submit, label: I18n.t('save')
      cancel_link
    end
    f.inputs I18n.t('History_Type_Details') do
      f.input :description, label: I18n.t('Description')
      # if f.object.new_record?
      #   f.input :active, label: I18n.t('Active'), input_html: {checked: true}
      # else
      #   f.input :active, label: I18n.t('Active')
      # end
    end
  end
end