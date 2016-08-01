class UserExtraSerializer < ActiveModel::Serializer
  attribute :fullname,key: :username , if: :fullname?
  attribute :gender, if: :gender?
  attribute :birthday, if: :birthday?
  attribute :identity_card
  attribute(:teacher_no) {"1"}
  attribute(:desc) {"1"}
  attribute(:school) {"1"}
  attribute(:district_id) {"1"}
  attribute(:grade) {"1"}
  attribute(:bj) {"1"}
  attribute(:student_code) {"1"}
  attribute(:address) {"1"}

  def fullname?
    @instance_options[:service_permission].fullname > 0
  end

  def gender?
    @instance_options[:service_permission].gender > 0
  end

  def birthday?
    @instance_options[:service_permission].birthday > 0
  end

  def identity_card?
    @instance_options[:service_permission].identity_card > 0
  end

end
