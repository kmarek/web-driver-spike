#!/usr/bin/ruby -w

require "selenium-webdriver"

class TestCase

	def name
		__method__
	end
	
	def setup
		# default setup, can be overriden in test case
		# open firefox and log in
		@browser = Selenium::WebDriver.for :firefox
		@browser.navigate.to "https://app.futuresimple.com/sales"
		@browser.manage.window.maximize

		@browser.find_element(:id, 'user_email').send_keys "kamil.marek@gmail.com"		
		pass_field = @browser.find_element(:id, 'user_password')		
		pass_field.send_keys "easypass"
		pass_field.submit

		page_title = @browser.title
		if page_title == "Base CRM"
			puts "Page '" + page_title + " has been loaded."
			return true
		else
			puts("Page 'Base CRM' is not loaded.")
			self.teardown
			exit
		end
	end

	def test_procedure
		#default test procedure, should be overriden in test case
	end

	def teardown
		# default teardown, can be overriden in test case
		# close browser
		@browser.close
		return true
	end

	def run
		r_setup = self.setup
		r_test_procedure = self.test_procedure
		r_teardown = self.teardown
		
		result = true
		[r_setup, r_test_procedure, r_teardown].each { |part_result| 
			if part_result == false
				result = false
			end
		}
		
		return result
	end
end