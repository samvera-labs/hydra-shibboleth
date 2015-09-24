class CreateHydraShibbolethUser < ActiveRecord::Migration
  def change
    create_table :hydra_shibboleth_users do |t|
      t.string :email,              :null => true, :default => ""
      t.string :full_name,          :null => true, :default => ""
      t.string :uid,                :null => false, :default => ""
      t.string :provider,           :null => false, :default => ""
      t.timestamps

      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    end

    add_index :hydra_shibboleth_users, :email,                :unique => true
    add_index :hydra_shibboleth_users, [:provider,:uid],      :unique => true
  end
end
