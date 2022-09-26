# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)    
    if @user = user 
      @user.admin? ? admin_abilities : user_abilities
    else
      quest_abilities
    end  
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    quest_abilities
    can :create, [Question, Answer, Comment]  

    can %i[update destroy], [Question, Answer, Comment], { author_id: user.id }

  end

  def quest_abilities
    can :read, :all
  end
end
