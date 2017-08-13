ActiveAdmin.register_page 'Dashboard' do

  menu priority: 1, label: proc{ I18n.t('active_admin.dashboard') }

  content title: proc{ I18n.t('active_admin.dashboard') } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    section "#{t('recently_updated_content')} - #{t('last_20_items')}" do
      table_for PaperTrail::Version.order('id desc').limit(20) , class: 'table table-responsive table-stripped' do # Use PaperTrail::Version if this throws an error
        column (t('Item')) { |v| v.item }
        #column ('Item') { |v| link_to v.item, [:admin, v.item] } # Uncomment to display as link
        column (t('Type')) { |v| v.item_type.underscore.humanize }
        column (t('Modified_at')) { |v| v.created_at.to_s :long }
        column (t('Admin')) { |v| link_to User.find((v.whodunnit.nil? ? '1' : v.whodunnit)).name, [:admin, User.find((v.whodunnit.nil? ? '1' : v.whodunnit))] }
      end
    end
  end # content
  # Here is an example of a simple dashboard with columns and panels.
  #
  # columns do
  #   column do
  #     panel "Recent Posts" do
  #       ul do
  #         Post.recent(5).map do |post|
  #           li link_to(post.title, admin_post_path(post))
  #         end
  #       end
  #     end
  #   end

  #   column do
  #     panel "Info" do
  #       para "Welcome to ActiveAdmin."
  #     end
  #   end
  # end

  #     # Relation-resource
  #     ActiveAdmin.register User do
  #       include ActiveAdmin::AjaxFilter
  #       # ...
  #     end
  #
  #     # Main resource
  #     # As a filter
  #     ActiveAdmin.register Invoice do
  #       filter :user, as: :ajax_select, data: {
  #           url: :filter_admin_users_path,
  #           search_fields: [:email, :customer_uid],
  #           limit: 7,
  #       }
  #       # ...
  #     end
  #
  #     # As a form input
  #     ActiveAdmin.register Invoice do
  #       form do |f|
  #         f.input :language # used by ajax_search_fields
  #         f.input :user, as: :ajax_select, data: {
  #             url: filter_admin_users_path,
  #             search_fields: [:name],
  #             static_ransack: { active_eq: true },
  #             ajax_search_fields: [:language_id],
  #         }
  #         # ...
  #       end
  #     end
  #     You can use next parameters in data hash:
  #
  # search_fields - fields by which AJAX search will be performed, required
  # limit - count of the items which will be requested by AJAX, by default 5
  # value_field - value field for html select element, by default id
  # ordering - sort string like email ASC, customer_uid DESC, by default it uses first value of search_fields with ASC direction
  # ransack - ransack query which will be applied, by default it's builded from search_fields with or and contains clauses, e.g.: email_or_customer_uid_cont
  # url - url for AJAX query by default is builded from field name. For inputs you can use url helpers, but on filters level url helpers isn't available,
  #   so if you need them you can pass symbols and it will be evaluated as url path (e.g. :filter_admin_users_path).
  #   String with relative path (like /admin/users/filter) can be used for both inputs and filters.
  # ajax_search_fields - array of field names. ajax_select input depends on ajax_search_fields values: e.g. you can scope user by languages.
  # static_ransack - hash of ransack predicates which will be applied statically and independently from current input field value
end
