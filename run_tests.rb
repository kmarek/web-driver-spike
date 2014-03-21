#!/usr/bin/ruby -w

require "./lib/TestSuite.rb"

test_suite = TestSuite.new

# task 1
test_suite.add_test("log_in_using_correct_credentials")
# task 2
test_suite.add_test("get_custom_fields")
#task 3
test_suite.add_test("test_custom_fields_on_new_edit_leads_form")
test_suite.run_suite
test_suite.generate_report