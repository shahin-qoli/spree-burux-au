class AddDeviseTwoFactorToSpreeUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_users, :encrypted_otp_secret, :string
    add_column :spree_users, :encrypted_otp_secret_iv, :string
    add_column :spree_users, :encrypted_otp_secret_salt, :string
    add_column :spree_users, :consumed_timestep, :integer
    add_column :spree_users, :otp_required_for_login, :boolean
    add_column :spree_users, :mobile_number, :string
    add_index :spree_users, :mobile_number, unique: true
    remove_index :spree_users, :email
    add_index :spree_users, :email
  end
end
