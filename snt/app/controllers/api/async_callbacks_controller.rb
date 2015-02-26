class Api::AsyncCallbacksController < ApplicationController
  before_filter :check_session
  
  def show
    @async_callback = AsyncCallback.find(params[:id])
  end
end