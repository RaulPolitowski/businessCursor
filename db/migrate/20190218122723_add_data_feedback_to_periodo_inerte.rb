class AddDataFeedbackToPeriodoInerte < ActiveRecord::Migration
  def change
    add_column :periodo_inertes, :data_feedback, :timestamp
    add_column :periodo_inertes, :user_feedback_id, :integer
  end
end
