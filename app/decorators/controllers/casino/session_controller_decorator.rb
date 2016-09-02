CASino::SessionsController.class_eval do
  before_action :set_referrer

  def logout
    sign_out
    session.clear
    @url = params[:url]
    if params[:service].present? && service_allowed?(params[:service])
      redirect_to URI.join(params[:service], "/").to_s, status: :see_other
    end
  end

end
