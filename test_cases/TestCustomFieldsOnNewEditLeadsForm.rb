#!/usr/bin/ruby -w

require "selenium-webdriver"
require "./lib/TestCase.rb"
require "./test_cases/GetCustomFields.rb"
require "pp"

class TestCustomFieldsOnNewEditLeadsForm < TestCase
	
	def test_procedure
		custom_fields_hash = GetCustomFields.new.get_custom_fields(@browser)

		if custom_fields_hash.empty?			
			puts "There is no custom fields for leads."
			return false
		end

		@browser.navigate.to "https://app.futuresimple.com/leads/new"

		wait = Selenium::WebDriver::Wait.new(:timeout => 40) 
		begin
		 	wait.until { @browser.find_element(:class, 'custom-fields-items') }
		rescue
			puts "Timeout reached. Element custom-fields-items has not been found."
		  	return false
		end		

		container = @browser.find_element(:class, 'custom-fields-items')
		custom_fields = container.find_elements(:class, 'control-group')
		
		custom_fields_leads_form = {}

		if custom_fields.length > 0		
			custom_fields.each { |element| 
				name = element.find_element(:tag_name, 'label').text
				begin
					# this is not correct type of custom-field
					# TODO: find a way to determine proper field type
					type = element.find_element(:tag_name, 'input').attribute("type")
				rescue Selenium::WebDriver::Error::NoSuchElementError
					#do nothing
				end

				custom_fields_leads_form[name] = type
			}
			
			difference = []
			result_p1 = true
			result_p2 = true

			if custom_fields_hash.length == custom_fields_leads_form.length
				puts "There are the same number of custom fields as configured"
			else
				result_p1 = false
				puts "Number of custom fields doesn't match settings: "
				puts "Settings: " + custom_fields_hash.length.to_s
				puts "Form: " + custom_fields_leads_form.length.to_s
			end

			# comparing only field names!
			custom_fields_hash.keys.each { |key| 
				if !custom_fields_leads_form.key?(key)
					difference << key
				end
			}

			if difference.empty?
				puts "All configured custom fields are present in leads form:"
				pp custom_fields_leads_form.keys
			else
				result_p2 = false
				puts "Field " + difference.to_s + " are not displayed in form."
			end

			return result_p1 && result_p2
		end
	end
end