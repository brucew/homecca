class Admin::UsersController < Admin::AdminController
  active_scaffold :user do |config|
    config.list.columns = [:avatar, :id, :last_name, :first_name, :email, :type]
    config.update.columns = [:avatar, :last_name, :first_name, :email, :email_confirmed,
                             :facebook_uid, :facebook_session, :role]
    config.action_links.add 'impersonate', :label => 'Impersonate', :type => :member,
                             :action => 'impersonate'
  end

  def impersonate
    @user = User.find(params[:id])
  end

  # link_to 'Impersonate', impersonation_path(:user_id => @user_id), :method => :post, :id => "impersonate_#{@user.id}"
end
