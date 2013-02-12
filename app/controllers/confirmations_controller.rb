class ConfirmationsController < BlueLightSpecial::ConfirmationsController

  def url_after_create
    '/?user=new'
  end

end