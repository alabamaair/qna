ProfilesPolicy = Struct.new(:user, :profiles) do
  def me?
    user.present?
  end

  def index?
    user.present?
  end
end
