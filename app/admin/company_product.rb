ActiveAdmin.register CompanyProduct do
  permit_params :description, :active

  menu parent: I18n.t('Companies'), priority: 2, label: I18n.t('Company_Product')

  index title: I18n.t('Company_Products') do
    selectable_column
    #id_column
    column I18n.t('Name') do |company|
      link_to company.description, admin_company_product_path(company)
    end
    #column I18n.t('Reference_Code'), :ref_code
    column I18n.t('Description'), :description
    bool_column I18n.t('Active'), :active
    column I18n.t('Created_at'), :created_at
    column I18n.t('Updated_at'), :updated_at
    actions
  end

  show do
    tabs do
      tab I18n.t('Company') do
        attributes_table do
          row I18n.t('Description') do
            resource.description
          end
          row I18n.t('Company_Product_Type') do
            resource.product_type_id
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
    end
    #active_admin_comments
  end

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
    f.inputs I18n.t('Company_Product_Details') do
      f.input :description, label: I18n.t('Description')
      f.input :active, label: I18n.t('Active'), input_html: {checked: 'checked'}
    end
  end

  # controller do
  #
  #   # Provide access to the parent resource record: Site.
  #   #
  #   # Without this extra setup the parent record will not be accessible. Any
  #   # calls to `#parent` will return the Arbre parent element and not the
  #   # ActiveAdmin resource.
  #   alias_method :site, :parent
  #
  #   # Expose the method as a helper making it available to the view
  #   helper_method :site
  #
  # end
end