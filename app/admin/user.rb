ActiveAdmin.register User do
  permit_params :name, :email, :phone, :password
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :created_at
    column :register_from
    actions
  end
end
