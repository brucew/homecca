# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :check_url
  geocode_ip_address
  include BlueLightSpecial::Authentication
  include SortableTable::App::Controllers::ApplicationController
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

#  before_filter :set_facebook_session
#  helper_method :facebook_session
  before_filter :authenticate
  require 'gritter'


  private

  def check_url
    if Rails.env == 'production' and request.env['HTTP_HOST'] != HOST
      head :moved_permanently, :location => request.protocol + HOST + request.request_uri
    end
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access(flash_message = nil)
    store_location
    flash[:failure] = flash_message if flash_message
    redirect_to(root_path)
  end

  def require_admin
    redirect_to root_url unless current_user.admin? or current_user.id == 1
  end

  def location_skill_search(klass, conditions = nil)
    @skills = params[:skills]
    @near = params[:near]

    if @near == '' or @near.nil?
      loc, @near, found = get_user_geolocation
    else
      loc = GeoKit::Geocoders::GoogleGeocoder.geocode(@near)
      found = loc.success
      @near = loc.full_address
    end

    if found
      bounds = Geokit::Bounds.from_point_and_radius(loc, Provider::NEARBY_DISTANCE)
      unless params[:sort] == 'distance'
        objs = klass.search_for(params[:skills]).find(:all,
                                                      :conditions => conditions,
                                                      :bounds => bounds,
                                                      :order => sort_order)
        objs.each do |o|
          o.class.send(:attr_accessor, :distance)
          o.distance = o.distance_to(loc)
        end
      else
        objs = klass.search_for(params[:skills]).find(:all,
                                                      :conditions => conditions,
                                                      :bounds => bounds)
        objs.sort_by_distance_from(loc)
      end
    else
      flash.now[:notice] = "Your location cannot be determined. Please enter it below."
      @near = ''
      objs = []
    end
    return objs
  end

  def get_user_geolocation
    if current_user and current_user.lat and current_user.lng
      loc = GeoKit::LatLng.new(current_user.lat, current_user.lng)
      found = true
      address = current_user.location
    else
#      loc = GeoKit::Geocoders::GeoPluginGeocoder.geocode(request.remote_ip)
      if loc = session[:geo_location]
        found = true
        address = loc.full_address
      end
    end
    return loc, address, found
  end

  def flash_error_count(object, object_name = nil)
    object_name = object.class.to_s.downcase if object_name.nil?
    if object.errors.count == 1
      flash.now[:error] = '1 error prevented this ' + object_name + ' from being saved.'
    else
      flash.now[:error] = object.errors.count.to_s + ' errors prevented this ' + object_name + ' from being saved.'
    end

  end

end