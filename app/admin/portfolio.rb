ActiveAdmin.register Portfolio do
  permit_params :name, :description, :active, :company_id

  menu parent: I18n.t('Companies'), priority: 3, label: I18n.t('Portfolios')

  index title: I18n.t('Portfolios') do
    selectable_column
    #id_column
    column I18n.t('Name') do |resource|
      link_to resource.name, admin_portfolio_path(resource)
    end

    bool_column I18n.t('Active'), :active
    column I18n.t('Companies'), :company
    column I18n.t('Created_at'), :created_at
    column I18n.t('Updated_at'), :updated_at
    actions
  end

  show do
    tabs do
      tab I18n.t('Portfolio') do
        attributes_table do
          row I18n.t('Name') do
            resource.name
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
      tab I18n.t('Campaigns') do
        table_for resource.campaigns do
          column I18n.t('Name'), :name
          column I18n.t('created_at'), :created_at
          column I18n.t('updated_at'), :update_at
        end
      end
    end
    #active_admin_comments
  end

  filter :name
  filter :active
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors
    f.actions do
      f.action :submit, label: I18n.t('save')
      cancel_link
    end
    f.inputs I18n.t('Portfolio_Details') do
      f.input :name, label: I18n.t('Name'), input_html: {autofocus: true}
      f.input :company_id, as: :select, collection: Company.all, include_blank: false, input_html: {class: 'select2'} #TODO: limit scope by user in the future
      if f.object.new_record?
        f.input :active, label: I18n.t('Active'), input_html: {checked: true}
      else
        f.input :active, label: I18n.t('Active')
      end
    end
  end

end