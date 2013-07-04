class AddLastSyncedEventToSources < ActiveRecord::Migration
  def change
    add_column :sources, :last_synced_event, :string
  end
end
