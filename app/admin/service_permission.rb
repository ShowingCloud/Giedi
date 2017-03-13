ActiveAdmin.register ServicePermission do

  permit_params :key_permissions

  json_editor

  form do |f|
    f.inputs do
      f.input :name
      f.input :key_permissions, as: :jsonb
    end

    f.actions
  end


end
