class CheckAttendenceCreate<%= (name+"_lists").camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :<%= name+"_lists" %> do |t|
      t.integer    :user_id,    null: false
      t.string     :user_name
      t.integer    :code
      t.string     :name   ,    null: false
      t.datetime   :start  ,    null: false
      t.datetime   :end    ,    null: false
      t.timestamps null: false
    end

  end
end
