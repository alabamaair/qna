ProfilesPolicy = Struct.new(:user, :profiles) do
  def me?
    user.present?
  end

  def list?
    user.present?
  end
end
