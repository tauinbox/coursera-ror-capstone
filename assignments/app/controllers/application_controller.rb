class ApplicationController < ActionController::API
  #make the connection between controller action and associated view
  include ActionController::ImplicitRender

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Mongoid::Errors::DocumentNotFound, with: :record_not_found

  rescue_from ActiveRecord::StatementInvalid, with: :statement_invalid

  protected
    def record_not_found(exception) 
      payload = {
        errors: { full_messages:["cannot find id[#{params[:id]}]"] }
      }
      render :json=>payload, :status=>:not_found
      Rails.logger.debug exception.message
    end

    def statement_invalid(exception)
      payload = {
        errors: { full_messages: exception.message.split("\n") }
      }
      render json: payload, status: :unprocessable_entity
      Rails.logger.debug exception.message
    end
end
