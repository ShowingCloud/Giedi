class UserExtraSerializer < ActiveModel::Serializer
  attributes :fullname, :gender, :birthday, :identity_card
end
