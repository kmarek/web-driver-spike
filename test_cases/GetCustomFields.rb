#!/usr/bin/ruby -w

require "./lib/TestCase.rb"
require 'pp'

class GetCustomFields < TestCase

	def test_procedure	
		puts "Navigating to https://app.futuresimple.com/settings/leads"	
		@browser.navigate.to "https://app.futuresimple.com/settings/leads"
				
		wait = Selenium::WebDriver::Wait.new(:timeout => 40) 
		begin
		 	wait.until { @browser.title == "Base CRM: Customize Leads" }
		rescue
			puts "Timeout reached. Actual page title: " + @browser.title
		  	return false
		end				

		# bug: custom fields are not displayed 
		# WORKAROUND: open contacts and leads again to display custom fields	
		@browser.find_element(:xpath, "//a[@href='/settings/contacts']").click		
		@browser.find_element(:xpath, "//a[@href='/settings/leads']").click
		
		sleep 5
		puts "Getting custom fields"
		container = @browser.find_element(:id, 'custom-fields')		
		custom_fields = container.find_elements(:class, 'control-label')		

		if custom_fields.length > 0
			custom_fields_hash = {}
			custom_fields.each { |element| 
				begin								
					type = element.find_element(:tag_name, 'span').text
					name = element.find_element(:tag_name, 'h4').text					
					name = name.sub(type, "").chop	

					custom_fields_hash[name] = type
				rescue Selenium::WebDriver::Error::NoSuchElementError
					#puts "this is not interesting element:P"
				end
			}

			puts "Custom fields [key => value]: " 
			pp custom_fields_hash
		end
	end
end