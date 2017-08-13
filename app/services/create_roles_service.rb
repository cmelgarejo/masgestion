class CreateRolesService
  def call
    roles = []
    role = Role.create!(name: 'admin') #create and assign admin role
    ap "ROLE: #{role.inspect}"
    roles << role
    role = Role.create!(name: 'campaign_admin') #create and assign campaign_admin role
    ap "ROLE: #{role.inspect}"
    roles << role
    role = Role.create!(name: 'campaign_user') #create and assign campaign_user role
    ap "ROLE: #{role.inspect}"
    roles << role
    role = Role.create!(name: 'external_user') #cerate and assign external_user role
    ap "ROLE: #{role.inspect}"
    roles << role
  end
end