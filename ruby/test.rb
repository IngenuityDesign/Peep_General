require_relative 'subscribe_controller'

# Set up the API Test

class SubscribeTest < ActiveSupport::TestCase

  test "response must not be nil" do
    controller = SubscribeController.new
    controller.doSubscribe "stephen@ingenuitydesign.com"
    data = controller.getLastResponseJSON
    assert_not_nil( data, "Got nil from subscribe controller" )
  end

end
