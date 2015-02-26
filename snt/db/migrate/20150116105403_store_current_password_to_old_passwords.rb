class StoreCurrentPasswordToOldPasswords < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.old_passwords ||= []
      user.old_passwords.unshift({:password => user.crypted_password, :salt =>  user.password_salt })
      user.old_passwords = user.old_passwords[0, 3]
      user.last_password_update_at = Time.now
      user.save
    end
  end
end
