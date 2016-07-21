class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar, :email
  has_one :user_extra

  def avatar
      object.avatar.small.url
  end
end
