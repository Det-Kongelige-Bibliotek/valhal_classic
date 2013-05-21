# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability
  include Hydra::Ability
  include Hydra::AccessControlsEnforcement


  def initialize(user)
    @user = user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      if user.depositor?
        can :manage, :all
      else
        can :read, :all
      end
    end
  end
end