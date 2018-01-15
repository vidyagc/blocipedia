class CustomFailure < Devise::FailureApp

  def respond
    if http_auth?
      http_auth
    else
        flash[:danger] = i18n_message
        redirect_to welcome_index_path
    end
  end
end