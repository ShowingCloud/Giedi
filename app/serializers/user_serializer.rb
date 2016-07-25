class UserSerializer < ActiveModel::Serializer
  
  attributes :id, :name, :avatar, :email
  has_one :user_extra, key: :more

  def avatar
    object.avatar.small.url
  end

end
