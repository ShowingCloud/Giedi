class UserSerializer < ActiveModel::Serializer

  attributes :id, :avatar, :email
  attribute :phone, key: :mobile
  attribute :name, key: :nickname
  # has_one :user_extra, key: :profile

  def avatar
    object.avatar.small.url
  end

end
