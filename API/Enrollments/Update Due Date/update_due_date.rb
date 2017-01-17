#=============
# Bridge LMS - Unsupported Implementation Script
# Michael A. Valadez
# 11.18.16
# Complete Historical Enrollments - Assumes Enrollment Already Exists
#=============
require 'csv'
require 'typhoeus'
require 'HTTParty'

#==========================Replace these values========================#

# Either provide values at prompt, or provide values between '' marks and remove nil.

# API Token provided by IC or Bridge Support. Token value only! Do not include 'Basic'
access_token = 'nil'

# Your Bridge domain. Do not include https://, or, bridgeapp.com.
bridge_domain = 'nil'

# Path to the CSV file containing the learner enrollment ID and due date.
csv_file = 'nil'

#---------------------Do not edit below this line unless you know what you're doing-------------------#

unless access_token
  puts 'What is your access token? Do not include "Authorization Basic", only the token'
  access_token = gets.chomp
  sleep(1)
end

unless bridge_domain
  puts 'What is your Bridge domain? Do not includes, "https://, or, bridgeapp.com"'
  bridge_domain = gets.chomp
  sleep(1)
end

unless csv_file
  puts 'Where is your enrollment update CSV located? e.g., "/Users/Name/Desktop/Example.csv"'
  csv_file = gets.chomp
  sleep(1)
end

unless File.exists?(csv_file)
  raise 'Error: cannot locate the CSV file at the specified file path. Please correct this and run again.'
end

base_url = "https://#{bridge_domain}.bridgeapp.com/api/author"
test_url = "#{base_url}/course_templates"

# Make generic API call to test token, domain, and env.
test = Typhoeus.get(test_url, headers: {'Content-Type'=>'application/json', 'accept'=>'application/json', 'Authorization'=>"Basic #{access_token}"}
)

unless test.code == 200
  raise 'Error: The token or domain variables are not set correctly. Please correct this and run again.'
end


CSV.foreach(csv_file, {:headers => true}) do |row|
  Typhoeus.patch("#{base_url}/enrollments/#{row['id']}",
                 params: { 'enrollments[0][id]' => row['id'], 'enrollments[0][end_at]' => row['end_at'] },
                 headers: {'Content-Type'=>'application/json', 'accept'=>'application/json', 'Authorization'=>"Basic #{access_token}"}
  )
  puts "Updated: Enrollment #{row['id']}, is now due at #{row['end_at']}"
end

puts 'Successfully updated due dates.'
sleep(1)
system('cls')

puts 'The program will now close.'
sleep(1)
