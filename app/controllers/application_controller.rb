class ApplicationController < ActionController::Base
  add_flash_types :success, :danger, :warning, :info

  def after_sign_in_path_for(resource)
    authenticated_root_path
  end
  
  def after_sign_out_path_for(resource_or_scope)
    unauthenticated_root_path
  end
end
