class UserSession < Authlogic::Session::Base
  consecutive_failed_logins_limit Setting.defaults[:consecutive_failed_logins_limit]
  find_by_login_method :find_by_login_or_email
  remember_me_for 2.weeks
  remember_me false

  def to_key
    new_record? ? nil : [send(self.class.primary_key)]
  end

  def persisted?
    false
  end

  def stale?
    user.present? && user.pms_sessions.empty? && super
  end
end
