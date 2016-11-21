class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role == Settings.roles[:admin]
      can :manage, :all
    elsif user.role == Settings.roles[:mod]
      can :manage, [Suggestion, Order, OrderProduct]
    end
  end
end
