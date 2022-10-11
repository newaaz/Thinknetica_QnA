class CreateSubscriptionUsersToQuestions < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :questions do |t|
      t.index :user_id
      t.index :question_id

      t.index [:user_id, :question_id], unique: true
    end
  end
end
