class Admin::AdminController < ApplicationController

  layout 'admin'

  before_filter :authenticate
  before_filter :check_role

  ActiveScaffold.set_defaults do |config|
    config.list.per_page = 100
  end

  def index
  end

  private

  def check_role
    redirect_to root_url unless current_user.admin? or current_user.id == 1
  end

end
