class UserSerializer < ActiveModel::Serializer

  attribute :id, key: :guid
  attributes :avatar, :email
  attribute :phone, key: :mobile
  attribute :name, key: :nickname
  attribute :profile

  def avatar
    object.avatar.as_json[:avatar]
  end

  def profile
    object.user_extra.info
  end

end
