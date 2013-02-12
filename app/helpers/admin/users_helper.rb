module Admin::UsersHelper
  def avatar_column(user)
    avatar_tag user, :size => :thumb
  end
end