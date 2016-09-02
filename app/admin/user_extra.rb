ActiveAdmin.register UserExtra do

  permit_params :info

  json_editor

  # specify the type does not necessarily
  form do |f|
    f.inputs do
      f.input :info, as: :jsonb
    end

    f.actions
  end


end
