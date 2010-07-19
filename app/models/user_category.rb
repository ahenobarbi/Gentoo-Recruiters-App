require 'permissions/set.rb'
class UserCategory < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end

  belongs_to :user
  belongs_to :question_category

  validates_uniqueness_of :user_id, :scope => :question_category_id

  multi_permission :create, :update, :destroy do
    return true if acting_user.try.role.try.is_recruiter?
    return true if user_is?(acting_user)

    false
  end

  def view_permitted?(field)
    return true if acting_user.try.role.try.is_recruiter?
    return true if user_is?(acting_user)
    return true if user.mentor_is?(acting_user)

    false
  end

  def before_create
    for group in QuestionGroup.unassociated_in_category(user, question_category).all
      chosen_question = rand(group.questions.count)
      UserQuestionGroup.create! :user => user, :question =>
        (Question.all :limit => 1, :offset => chosen_question, :conditions => {:question_group_id => group.id})[0]
    end
  end
end
