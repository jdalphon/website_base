class Gravatar
  def url (user, size = 250)
    if user.email == ""
      nil
    else
      hash = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{hash}.png?s=#{size}"
    end
  end
end