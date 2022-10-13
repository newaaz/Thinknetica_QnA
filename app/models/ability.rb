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

    can :create, [Question, Answer, Comment, Vote] 

    can %i[update destroy], [Question, Answer], { author_id: user.id }
    
    can %i[upvote downvote], [Question, Answer] do |votable|
      !user.author?(votable)
    end

    can :create_comment, [Question, Answer]

    can :destroy, Link, linkable: { author_id: user.id }

    can :set_best_answer, Question, { author_id: user.id }

    can :purge, ActiveStorage::Attachment do |file|
      user.author?(file.record)
    end

    can %i[create destroy], Subscription
  end

  def quest_abilities
    can :read, :all
  end
end
