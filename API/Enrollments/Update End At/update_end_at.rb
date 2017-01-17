#=============
# Bridge LMS - Unsupported Implementation Script
# Michael A. Valadez
# 11.18.16
# Set Learner Enrollment Expiration - Requires 'End At - Re-Enrollment Feature'
#=============
require 'csv'
require 'typhoeus'

#========================Replace these values=======================#

# Either provide values at prompt, or provide values between '' marks and remove nil.

access_token = 'nil' # place your basic token between '' marks
domain = 'nil' # place your Bridge domain between '' marks
csv_file = 'nil' # file path to CSV containing learner session ID and user ID

#-------------------Do not edit below this line---------------------#

unless access_token
  puts 'What is your access token? Do not include "Authorization Basic", only the token'
  access_token = gets.chomp
end

unless domain
  puts 'What is your Bridge domain? Do not include "httpsMDZhNGYwNmMtMjRhMS00MzRhLWI1ODUtYzY1ZTA2NGJlNjJhOjhjZWM0MTIwLTY5MWEtNGNkZS05MDFiLWQ4MGE4Y2Y0MGZlZQ://", or, ".bridgeapp.com"'
  domain = gets.chomp
end

unless csv_file
  puts 'Where is your enrollments update CSV located?, e.g., "/Users/Name/Desktop/Example.csv" '
  csv_file = gets.chomp
end

unless File.exists?(csv_file)
  raise "Error: can't locate the update CSV"
end

base_url = "https://#{domain}.bridgeapp.com/api/author"
test_url = "#{base_url}/course_templates"


# Make generic API call to test token, domain, and env.
test = Typhoeus.get(test_url,
                    headers: {'Content-Type'=>'application/json', 'accept'=>'application/json', 'Authorization'=>"Basic #{access_token}"}
)

unless test.code == 200
  raise 'Error: The token or domain variables are not set correctly'
end

CSV.foreach(csv_file, {:headers => true}) do |row|
 response = Typhoeus.patch("#{base_url}/enrollments/#{row['id']}",
                 params: { 'enrollments[0][end_at]' => row['end_at'] },
                 headers: {'Content-Type'=>'application/json', 'accept'=>'application/json', 'Authorization'=>"Basic #{access_token}"}
  )
  puts "#{row['id']}, #{row['end_at']}"
  puts response.code
end

puts 'Successfully updated enrollments'
