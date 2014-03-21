#!/usr/bin/ruby -w

require "selenium-webdriver"

class TestCase	
	def initialize
		@result = true
	end

	def set_result(result)
		@result = @result && result
	end

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
			set_result true
			puts "Page '" + page_title + " has been loaded."			
		else
			set_result false
			puts("Page 'Base CRM' is not loaded.")
			self.teardown
			exit
		end
	end

	def test_procedure
		#default test procedure, should be overriden in test case
		set_result false
	end

	def teardown
		# default teardown, can be overriden in test case
		# close browser
		@browser.close
		set_result true
	end

	def run		
		setup
		test_procedure
		teardown
		@result
	end
end