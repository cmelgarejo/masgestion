# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# company = CreateCompanyService.new.call
# ap "CREATED ADMIN COMPANY: #{company.name}"
ap 'CREATING ROLES:'
roles = CreateRolesService.new.call

user = CreateAdminService.new.call(roles)
ap "CREATED ADMIN USER: #{user.name} - #{user.email}"