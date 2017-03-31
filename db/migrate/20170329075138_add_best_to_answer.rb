class AddBestToAnswer < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :best, :boolean, default: false, null: false
    add_column :questions, :best_answer_id, :integer
  end
end
