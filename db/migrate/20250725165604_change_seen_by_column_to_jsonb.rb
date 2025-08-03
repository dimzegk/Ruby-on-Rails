class ChangeSeenByColumnToJsonb < ActiveRecord::Migration[8.0]
  def change
    change_column :group_messages, :seen_by, :jsonb, using: 'seen_by::jsonb', default: []
  end
end
