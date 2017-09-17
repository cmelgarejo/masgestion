ActiveAdmin.register Company do
  permit_params :name, :description, :active

  menu parent: I18n.t('Companies'), priority: 1, label: I18n.t('Companies')

  index title: I18n.t('Companies') do
    selectable_column
    #id_column
    column I18n.t('Name') do |resource|
      link_to resource.name, admin_company_path(resource)
    end
    column I18n.t('Description'), :description
    #column I18n.t('Reference_Code'), :ref_code
    bool_column I18n.t('Active'), :active
    column I18n.t('Created_at'), :created_at
    column I18n.t('Updated_at'), :updated_at
    actions
  end

  show do
    tabs do
      tab I18n.t('Company') do
        attributes_table do
          row I18n.t('Name') do
            resource.name
          end
          row I18n.t('Description') do
            resource.description
          end
          bool_row I18n.t('Active') do
            resource.active
          end
          row I18n.t('Created_at') do
            resource.created_at
          end
          row I18n.t('Updated_at') do
            resource.updated_at
          end
        end
      end
      tab I18n.t('Products') do
        panel I18n.t('Products') do
          table_for resource.company_products do
            column I18n.t('Description'), :description
            column I18n.t('created_at'), :created_at
            column I18n.t('updated_at'), :update_at
          end
        end
      end
    end
    #active_admin_comments
  end

  filter :name
  filter :description
  filter :active
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.actions do
      f.action :submit, label: I18n.t('save')
      cancel_link
    end
    f.inputs I18n.t('Company_Details') do
      f.input :name, label: I18n.t('Name'), input_html: {autofocus: true}
      f.input :description, label: I18n.t('Description')
      if f.object.new_record?
        f.input :active, label: I18n.t('Active'), input_html: {checked: true}
      else
        f.input :active, label: I18n.t('Active')
      end
    end
  end

end