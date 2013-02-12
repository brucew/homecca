class PasswordsController < BlueLightSpecial::PasswordsController

  def url_after_create
    :back
  end

end