class AddDefaultToUserLanguage < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :language, "en"
  end
end
