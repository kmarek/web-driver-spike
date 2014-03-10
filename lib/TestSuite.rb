#!/usr/bin/ruby -w

class TestSuite

	def initialize
		@tests = []
		@results = []
	end

	def add_test(test_name)
		if test_name != ""
			@tests << test_name
		else
			puts "Test " + test_name + "does not exist."
		end
	end

	def run_suite
		if !@tests.empty?
			@tests.each { |test| 
				puts "Running test " + test
				run(test) 
			}
		else
			puts "There is no test to run."
		end
	end

	def run(test_name)
		# change test_case_name to TestCaseName		
		class_name = test_name.to_s.downcase.split("_").map {|word| word.capitalize}.join
		
		# run test case unless it's not implemented
		if implemented?(class_name)
			require "./test_cases/" + class_name + ".rb"

			result = eval(class_name).new.run
			puts "result: " + result.to_s
			@results << result
		else
			puts "Test " + class_name + " is not implemented."
		end
	end

	def generate_report
		puts ""
		puts "TEST REPORT"

		@results.each_with_index { |result, index| 			
			print "Test " + @tests[index]
			puts result ? " PASSED" : " FAILED" 
		}
	end

	def implemented?(class_name)
		Dir.glob('./test_cases/*.rb').each {|file| 
			if File.basename(file) == class_name + ".rb"							
				return true
			end
		}
		return false
	end
end