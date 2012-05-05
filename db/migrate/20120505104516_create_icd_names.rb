class CreateIcdNames < ActiveRecord::Migration
  def change
    create_table :icd_names do |t|

      t.timestamps
    end
  end
end
