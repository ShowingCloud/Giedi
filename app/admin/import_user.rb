ActiveAdmin.register_page "ImportUser" do
    content do
      render partial: 'import_user'
    end

  page_action :csv, method: :post do
      begin
        User.import_csv(params[:file])
        redirect_to admin_importuser_path, notice: "用户数据已导入"
      rescue
        redirect_to admin_importuser_path, notice: "用户数据导入失败"
      end
  end

end
