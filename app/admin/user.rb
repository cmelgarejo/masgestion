ActiveAdmin.register User do
  permit_params :name, :email, :password, :roles, :company_id, :role_ids#, :country, :region, :city
  actions :all, except: [:show]

  menu priority: 10, label: I18n.t('Users')

  index do
    title I18n.t('Users')
    selectable_column
    column I18n.t('Name') do |user|
      link_to user.name, edit_admin_user_path(user)
    end
    column :email
    list_column :my_roles
    list_column :my_companies
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :company
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.actions
    f.inputs t('user_details') do
      f.input :name, input_html: { autofocus: true }
      f.input :email
      f.input :password
      f.input :companies, as: :select, collection: Company.all, label: I18n.t('Companies'), include_blank: true, input_html: {class: 'select2'} #TODO: limit scope by user in the future
      f.input :roles, as: :select, collection: User.roles_for_select, label: I18n.t('Roles'), include_blank: false, input_html: {class: 'select2'} #TODO: limit scope by user in the future
    end
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

end
