require 'mailchimp'
require 'json'

class SubscribeController #< ActionController::Base

  def setup
    @mc = Mailchimp::API.new("7e42a6fa0eaa4c9b076b2cd33320b5a7-us3")
    @list = "f781744731"
  end

  def doSubscribe email = ""

    if (@mc.nil?)
      self.setup
    end

    begin
      if (email)
        @mc.lists.subscribe(@list, {'email' => email})
        returnData = {
          :status => "ok",
          :data => {
            :msg => "#{email} subscribed successfully",
            :code => 200
          }
        }
      else
        returnData = {
          :status => "nok",
          :data => {
            :msg => "Please enter your email",
            :code => 403
          }
        }
      end
    rescue Mailchimp::ListAlreadySubscribedError
      returnData = {
        :status => "nok",
        :data => {
          :msg => "#{email} is already subscribed",
          :code => 401
        }
      }
    rescue Mailchimp::ListDoesNotExistError
      returnData = {
        :status => "nok",
        :data => {
          :msg => "List #{list_id} does not exist",
          :code => 404
        }
      }
    rescue Mailchimp::Error => ex
      if ex.message
        returnData = {
          :status => "nok",
          :data => {
            :msg => ex.message,
            :code => 0
          }
        }
      else
        returnData = {
          :status => "nok",
          :data => {
            :msg => "Unknown error has occurred",
            :code => 0
          }
        }
      end

      # if you're using rails you likely just want to pass this data to a view
      # return returnDate

      @lastResponseJSON = JSON.generate(returnData)
      return returnData

    end

  end

  def subscribe
    if (email.nil?)
      if (params[:email].nil?)
        email = ""
      else
        email = params[:email]
      end
    end

    data = doSubscribe email

  end

  def getLastResponseJSON

    unless (@lastResponseJSON.nil?)
      return @lastResponseJSON
    else
      return nil
    end

  end

end
