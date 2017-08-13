ActiveAdmin.register Company do
  permit_params :name, :description, :enabled

  menu priority: 2, label: I18n.t('Companies')

  index title: I18n.t('Companies') do
    selectable_column
    #id_column
    column I18n.t('Name') do |company|
      link_to company.name, admin_company_path(company)
    end

    column I18n.t('Description'), :description
    bool_column I18n.t('Enabled'), :enabled
    column I18n.t('Created_at'), :created_at
    column I18n.t('Updated_at'), :updated_at
    actions
  end

  show do
    attributes_table do
      row I18n.t('Name') do
        resource.name
      end
      row I18n.t('Description') do
        resource.description
      end
      bool_row I18n.t('Enabled') do
        resource.active
      end
      row I18n.t('Created_at') do
        resource.created_at
      end
      row I18n.t('Updated_at') do
        resource.updated_at
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
    f.actions do
      f.action :submit, label: I18n.t('save')
      cancel_link
    end
    f.inputs I18n.t('Company_Details') do
      f.input :name, label: I18n.t('Name'), input_html: { autofocus: true }
      f.input :description, label: I18n.t('Description')
      f.input :active, label: I18n.t('Enabled'), input_html: { checked: 'checked' }
    end
  end

end