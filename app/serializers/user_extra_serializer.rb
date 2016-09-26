class UserExtraSerializer < ActiveModel::Serializer
  attribute :info

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
