require 'rspec'
require 'rubygems'
require 'C:\Users\kkotra\RubymineProjects\sales-apttus-automated-tests\spec_helper'
require 'C:\Users\kkotra\RubymineProjects\sales-apttus-automated-tests\tester\generatedocumnentforacardtester'

describe 'Gen_An_Agreement_Doc' do
  before(:all) do
    @tester = GenerateDocumnentForACardTester.new
    @tester.salesforce_login
  end

  it 'selecting standard card type from an existing opportunity with default options and extracting the agreement_id generated from the agreement document' do
    @tester.selecting_existing_opportunity
    @tester.selecting_cards
    @tester.sending_approvals_for_proposal
  end

  it 'selecting standard card type from an existing opportunity with change in gross option and extracting the agreement_id generated from the agreement document' do
    @tester.selecting_existing_opportunity
    @tester.selecting_cards(:change_gross => true)
    @tester.sending_approvals_for_proposal
  end

end

# def remote_request
#   begin
#     response = RestClient.get my_request_url
#   rescue RestClient::ResourceNotFound => error
#     @retries ||= 0
#     if @retries < @max_retries
#       @retries += 1
#       retry
#     else
#       raise error
#     end
#   end
#   response
# end

# # require 'watir-webdriver'
#
# #Specify the driver path
# chromedriver_path = File.join(File.absolute_path('../..', File.dirname(__FILE__)),"browsers","chromedriver.exe")
# Selenium::WebDriver::Chrome.driver_path = chromedriver_path
#
# # Start the browser as normal
# b = Watir::Browser.new :chrome
# b.goto 'www.google.com'