class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end


  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end

# class ApplicationPolicy
#   attr_reader :user, :record
#
#   def initialize(user, record)
#     @user = user
#     @record = record
#   end
#
#   def index?
#     true
#   end
#
#   def show?
#     scope.where(id: record.id).exists?
#   end
#
#   def new?
#     create?
#   end
#
#   def create?
#     true
#   end
#
#   def edit?
#     update?
#   end
#
#   def update?
#     true
#   end
#
#   def destroy?
#     true
#   end
#
#   def destroy_all?
#     true
#   end
#
#   def scope
#     Pundit.policy_scope!(user, record.class)
#   end
# end

