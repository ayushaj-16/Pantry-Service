# Service to validate user that is logged in
class CheckAuthService
  def self.check(token)
    user = User.find_by_token(token)
    !user.blank? && user[:expireAt] > Time.now
  end
end
