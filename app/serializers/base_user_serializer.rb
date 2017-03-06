class BaseUserSerializer < ActiveModel::Serializer

  attribute :id
  attributes :avatar, :email
  attribute :phone, key: :mobile
  attribute :name, key: :nickname

  def avatar
    object.avatar.as_json[:avatar]
  end

end
