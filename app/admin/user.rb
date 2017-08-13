ActiveAdmin.register User do
  permit_params :name, :email, :password, :roles, :company_id, :role_ids, :country, :state, :city
  actions :all, :except => [:show]

  menu label: I18n.t('Users')

  index do
    title I18n.t('Users')
    selectable_column
    id_column
    column I18n.t('Name') do |user|
      link_to user.name, edit_admin_user_path(user)
    end
    column :email
    list_column :my_roles
    list_column I18n.t('Companies'), :my_companies
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
    f.inputs t('user_details') do
      f.input :name, input_html: { autofocus: true }
      f.input :email
      f.input :password
      f.input :company_id, as: :select, collection: Company.all
      f.input :roles, as: :select, label: I18n.t('Roles'), include_blank: false, input_html: {class: 'select2'}
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

end
