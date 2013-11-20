class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


 def tracking_info
    rendered_time = Time.now
    referer = request.env['HTTP_REFERER']
    if !@user = User.find_by(name: request.session.id)
      @user = User.create_anonymous
      @user.name = request.session.id
      @user.save!
    end
    [rendered_time, referer, @user]
  end
  
  def create_item_result(item)
    rendered_time, referer, user = tracking_info
    user.item_results.create!(
      :identifier => item.identifier,
      :item_id => item.id,
      :rendered_datestamp => rendered_time,
      :referer => referer,
      :ip_address => request.ip,
      :session_status => 'initial')
  end
end
