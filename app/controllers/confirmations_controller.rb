class ConfirmationsController < Milia::ConfirmationsController
  
  
  def update
    if @confirmable.attempt_set_password(user_params)
      
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?
      
      if resource.errors.empty?
        log_action( "invitee confirmed" )
        set_flash_message(:notice, :confirmed) if is_flashing_format?
        
        sign_in_tenanted_and_redirect(resource)
        
      else
        log_action( "invitee confirmation failed" )
        respond_with_navigational(resource.errors, :status => :unprocessable_entity) { render :new }
      end
      
    else
      log_action( "invitee password set failed" )
      prep_do_show()
      respond_with_navigational(resource.errors, :status => :unprocessable_entity) { render :show }
    end
  end
  
  
  private
  def set_confirmable()
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, 
                                                          params[:confirmation_token])
    
  end
  
end