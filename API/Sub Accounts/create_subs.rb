#=============
# Bridge LMS - Unsupported Implementation Script
# Michael A. Valadez
# 11.13.16
# Update Sub Accounts
#=============
require 'csv'
require 'typhoeus'
require 'Unirest'
require 'HTTParty'

#========================Replace these values=======================#

# Either provide values at prompt, or provide values between '' marks and remove nil.

access_token = 'nil' # place your basic token between '' marks
domain = 'nil' # place your Bridge domain between '' marks
csv_file = 'nil' # file path to CSV containing sub account information

#-------------------Do not edit below this line---------------------#

unless access_token
  puts 'What is your access token? Do not include "Authorization Basic", only the token'
  access_token = gets.chomp
end

unless domain
  puts 'What is your Bridge domain? Do not include "https://", or, ".bridgeapp.com"'
  domain = gets.chomp
end

unless csv_file
  puts 'Where is your sub account create CSV located?, e.g., "/Users/Name/Desktop/Example.csv" '
  csv_file = gets.chomp
end

unless File.exists?(csv_file)
  raise "Error: can't locate the update CSV"
end

test_url = "https://#{domain}.bridgeapp.com/api/author/course_templates"


# Make generic API call to test token, domain, and env.
test = Typhoeus.get(test_url,
                    headers: {'Content-Type'=>'application/json', 'accept'=>'application/json', 'Authorization'=>"Basic #{access_token}"}
)

unless test.code == 200
  raise 'Error: The token or domain variables are not set correctly'
end

CSV.foreach(csv_file, {:headers => true}) do |row|
  Typhoeus.post("https://#{domain}.bridgeapp.com/api/admin/sub_accounts",
                 params: {'sub_account':{'subdomain' => row['subdomain'], 'name' => row['name'] , 'contact_name' => row['contact_name'], 'contact_phone' => row['contact_phone'], 'contact_email' => row['contact_email'], 'time_zone' => row['time_zone'] }},
                 headers: {'Content-Type'=>'application/json', 'accept'=>'application/json', 'Authorization'=>"Basic #{access_token}"}
  )
  puts "Creating Sub Account #{row['name']}"
end

sleep(5)
puts 'Successfully created sub accounts'
