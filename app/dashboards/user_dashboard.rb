require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user_extra: Field::HasOne,
    id: Field::Number,
    name: Field::String,
    email: Field::String,
    phone: Field::String,
    password_digest: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    confirmation_digest: Field::String,
    confirmed: Field::Boolean,
    confirmed_at: Field::DateTime,
    reset_digest: Field::String,
    reset_sent_at: Field::DateTime,
    reset_pin: Field::String,
    reset_pin_sent_at: Field::DateTime,
    new_email: Field::String,
    avatar: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user_extra,
    :id,
    :name,
    :email,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user_extra,
    :id,
    :name,
    :email,
    :phone,
    :password_digest,
    :created_at,
    :updated_at,
    :confirmation_digest,
    :confirmed,
    :confirmed_at,
    :reset_digest,
    :reset_sent_at,
    :reset_pin,
    :reset_pin_sent_at,
    :new_email,
    :avatar,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user_extra,
    :name,
    :email,
    :phone,
    :password_digest,
    :confirmation_digest,
    :confirmed,
    :confirmed_at,
    :reset_digest,
    :reset_sent_at,
    :reset_pin,
    :reset_pin_sent_at,
    :new_email,
    :avatar,
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user)
  #   "User ##{user.id}"
  # end
end
