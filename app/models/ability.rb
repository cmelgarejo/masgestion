class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # support guest user
    if user.has_role?(:admin)
      can :manage, :all
    end
    if user.has_role?(:campaign_admin)
      can :manage, [Campaign, Client, Company, CompanyProduct, User]
    end
    if user.has_role?(:campaign_user) && !user.has_role?(:admin) && !user.has_role?(:campaign_admin)
      can :manage, Client
      #can :read, [Company, User]
    end
    if user.has_role?(:external_user) #Shall have it's own Dashboard and etc
      #can :read, CompanyProducts, company_id: user.company.id
    end
  end
end
