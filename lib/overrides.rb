# This is commented out because it was part of the original Facebook/Clearance integration
# This is now done by blue-light-special gem
#module Clearance
#
#  module Authentication
#    module InstanceMethods
#      def current_user
#        @_current_user ||= (user_from_cookie || user_from_session || user_from_fb)
#      end
#
#      def user_from_fb
#        if facebook_session
#          current_user = ::User.find_by_fb_user(facebook_session.user)
#        end
#        return current_user
#      end
#    end
#  end
#
#  module User
#    module Validations
#      def self.included(model)
#        model.class_eval do
#          #validates_presence_of     :email
#          #validates_uniqueness_of   :email, :case_sensitive => false
#          #validates_format_of       :email, :with => %r{.+@.+\..+}
#          #
#          #validates_presence_of     :password, :if => :password_required?
#          #validates_confirmation_of :password, :if => :password_required?
#        end
#      end
#    end
#  end
#
#end
