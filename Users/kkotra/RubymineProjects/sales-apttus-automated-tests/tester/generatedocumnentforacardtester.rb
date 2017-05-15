require 'rubygems'
require 'rspec/expectations'
# require 'rspec/mocks/verifying_message_expectation'
require 'selenium-webdriver'
require 'watir-webdriver'
require 'base64'

class GenerateDocumnentForACardTester
  def initialize
    @browser = Watir::Browser.new :ie
    @browser.goto "https://test.salesforce.com/"
    @tries = 0
    @legal_entity_window_url = ''
  end

  def salesforce_login
    ## logging into salesforce
    @browser.text_field(:name, "username").set("kkotra@netjetsus.com.gcmqa")

    password = 'S2FwcGlwd2QxKg==\n'
    @browser.text_field(:name, "pw").set(Base64.decode64(password))

    @browser.checkbox(:name, "rememberun")
    @browser.button(:name, "Login").when_present.click
    @browser.link(:href, '/home/home.jsp').when_present.click
  end

  def selecting_existing_opportunity
    ## getting into opportunities tab
    @tries = 4
    begin
      @browser.link(:href, '/006/o').when_present.click
      sleep 2
      @browser.select_list(:name => 'fcf').option(:value => '00BE00000055LT5').select ## selecting all open opportunities
      @browser.button(:name, "go").when_present.click
      # browser.ul(:id => 'navigation').lis.first #########3 TODO try this code
      @browser.link(:href, 'javascript:ListViewport.instances%5B%2700BE00000055LT5%27%5D.getListData%28%7B%27rolodexIndex%27%3A6%7D%29').when_present.click ## getting all opportunities that begins with 'G'
      @browser.div(:id, '0062C000002DBgj_OPPORTUNITY_NAME').link(:href, '/0062C000002DBgj').when_present.click ## selecting Grimey Zombie(Grimes) opportunity
    rescue Watir::Exception::UnknownObjectException => e
      @tries -= 1
      if @tries > 0
        retry
      else
        raise e
      end
    end
  end


  def selecting_cards(options = {})
    @browser.button(:title => 'Go to Card Catalog', :text => 'Go to Card Catalog').when_present.click ## Go to card catalog
    choosing_card
    selecting_standard_card_with_default_options
    @browser.li(:class, 'aptSpinnerBtn').link(:id, 'j_id0:idLineItemSO:j_id322:0:j_id325').click ## saving item
  end

  def choosing_card
    @tries = 4
    begin
      @browser.image(:class, 'aptCarrouselImage').when_present.click ## selecting Cards
      @browser.link(:id, 'j_id0:idForm:j_id178:4:idConfigureButton').when_present.click ## configure standard card
    rescue Watir::Exception::UnknownObjectException => e
      @tries -= 1
      if @tries > 0
        retry
      else
        raise e
      end
    end
  end

  def selecting_standard_card_with_default_options
    @tries = 4
    begin
      @browser.select_list(:id => 'j_id0:idLineItemSO:idAttributeGroups:0:idProductAttributeGroupsBlock:j_id164:j_id165:0:j_id166:attributeValueInput', :class => 'Aircraft_1_Type__c Aircraft_1_Type__c_input')
          .option(:value => 'Citation Excel').when_present.select ## Aircraft Type => Citation Excel
      @browser.img(:src, '/resource/Apttus_Button_Update_Product').when_present.click ## update item
    rescue Watir::Exception::UnknownObjectException => e
      @tries -= 1
      if @tries > 0
        retry
      else
        raise e
      end
    end
  end

  def sending_approvals_for_proposal
    @tries = 4
    begin
      if @browser.td(:class, 'aptSelectedProductColumn2').span(:id, 'j_id0:idLineItemSO:idMiniCartComponent:j_id172:j_id192:0:j_id218').div.span(:text, 'Citation Excel  / 25').exists?
        @browser.img(:src, '/resource/Apttus_Button_Update_Product').when_present.click ## update item
      end
      @browser.li(:id, 'Go To CDR').link(:id, 'j_id0:idForm:j_id396:8:j_id399').when_present.click ## Go to CDR

      select_existing_legal_entity

    rescue Watir::Exception::UnknownObjectException => e
      @tries -= 1
      if @tries > 0
        retry
      else
        raise e
      end
    end
  end

  def select_existing_legal_entity
    sleep 2
    @browser.img(:src => '/resource/Select_Existing_Legal_Entity').when_present.click ## select existing legal entity button

    @tries = 4
    begin
      @browser.windows.each do |row|
        sleep 2
        if row.url.include? 'https://c.cs59.visual.force.com/apex/APTS_SelectLegalEntity?'
          sleep 3
          @legal_entity_window_url = row.url
        end
      end
    rescue Watir::Exception::NoMatchingWindowFoundException => e
      @tries -= 1
      if @tries > 0
        retry
      else
        raise e
      end
    end

    @browser.window(:url => "#{@legal_entity_window_url}").use do
      @browser.link(:text => 'Grimey Zombie').when_present.click
      quote_proposal
    end
  end

  def quote_proposal
    sleep 2
    @legal_entity_window_url = @browser.windows.last.use.url

    @browser.windows.last.use do
      if @browser.td(:class => 'dataCol col02', :text => 'Grimey Zombie').exists?
        @browser.img(:src, '/resource/Apttus_Proposal__Button_MakePrimary').when_present.click
        sleep(3)
        if @browser.img(:src, '/img/checkbox_checked.gif').exists?
          @browser.buttons.each do |index|
            if index.name == 'j_id0:frm2:btnProposal'
              puts "index is #{index}"
            end
          end
          # @browser.button(:id, 'j_id0:frm1:btnCdr').when_present(60).click
        end

      end
    end

  end


end