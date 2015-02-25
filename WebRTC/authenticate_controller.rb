class AuthenticateController < ApplicationController
  def index
    if !session[:email].nil?
      redirect_to '/http/chat'
      return
    end
  end

  def success
    if session[:email].nil? || session[:email] == ''
      require 'net/http'
      require 'net/https'
      
      if session[:authtoken].nil?
        redirect_to '/http/authenticate/index#error'
        return
      end
      url = URI.parse('https://www.googleapis.com/oauth2/v1/userinfo?access_token='+session[:authtoken])
      request = Net::HTTP::Get.new(url.path, {'Authorization' => 'Bearer '+session[:authtoken]})
      response = Net::HTTP.new(url.host, url.port)
      response.use_ssl=true;
      response.start do |http|
        @response_result = http.request(request)
      end
      @profile_info = ActiveSupport::JSON.decode @response_result.body

      if !@profile_info['email'].nil?
        if @profile_info['email'].split('@').last != 'qburst.com'
          redirect_to '/http/authenticate/index#noqb'
          return
        end
        session[:email] = @profile_info['email'];
        session[:name] = @profile_info['name'];
      end
    end

    if session[:email].nil?
      redirect_to '/http/authenticate/index#error'
      return
    end
  end

  def pre_login
  end

  def catchtoken
    session[:authtoken] = params[:access_token]
    respond_to do |format|
      format.json { render :json => {} }
    end
  end
  
end
