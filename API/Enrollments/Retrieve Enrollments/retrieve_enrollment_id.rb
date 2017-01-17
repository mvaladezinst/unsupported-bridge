#=============
# Bridge LMS - Unsupported Implementation Script
# Michael A. Valadez
# 11.13.16
# Retrieve Enrollment IDs - Can be done through data dump as well.
#=============
require 'csv'
require 'unirest'
require 'rubygems'
require 'json'
require 'typhoeus'
require 'HTTParty'
require 'highline/import'

#==========================Replace these values========================#

# Either provide values at prompt, or provide values between '' marks and remove nil.

# API Token provided by IC or Bridge Support. Token value only! Do not include 'Basic'
$access_token = 'nil'

# Your Bridge domain. Do not include https://, or, bridgeapp.com.
$bridge_domain = 'nil'

# Location where you would like the CSV to be exported to. Leave blank to default to project folder.
$csv_file = 'nil'

# Bridge course ID to pull enrollment ID's from
$course_id = 'nil'

#---------------------Do not edit below this line unless you know what you're doing-------------------#


unless $bridge_domain
  puts "What is your Bridge domain?\nNote: Only the domain is needed.\b"
  $bridge_domain = gets.chomp
end

system('cls')

unless $csv_file
  puts "What should I name your CSV file?\b"
  $csv_file = gets.chomp
end

system('cls')

puts 'Testing user defined variables...'
sleep(1)
system('cls')
unless File.exists?($csv_file)
  raise 'Error: cannot locate the CSV file at the specified file path. Please correct this and run again.'
end

base_url = "https://#{$bridge_domain}.bridgeapp.com/api/author"
test_url = "#{base_url}/course_templates"

# Make generic API call to test token, domain, and env.
test = Typhoeus.get(test_url, headers: {'Content-Type'=>'application/json', 'accept'=>'application/json', 'Authorization'=>"Basic #{$access_token}"}
)

unless test.code == 200
  raise 'Error: The token or domain variables are not set correctly. Please correct this and run again.'
end


puts 'Retrieving User and Enrollment IDs from '+$bridge_domain
sleep(1)
system('cls')
puts 'Exporting User and Enrollment IDs, to ' +$csv_file+'.csv'
sleep(1)
system('cls')

CSV.open($csv_file+'.csv', 'wb') do |headers|
  headers << %w(enrollment_id user_id)
end

class Get_Enrollment_ID

  headers = {'Authorization' => 'Basic '+$access_token, 'Content-Type' => 'application/json', 'Accept' =>
      'application/json'}

  $usr_url = 'https://'+$bridge_domain+'.bridgeapp.com/api/author/course_templates/'+$course_id+'/enrollments?limit=1000'

  response = HTTParty.get($usr_url, :headers => headers)
  json = JSON.parse(response.body)['enrollments']


  json.each do |x|
    CSV.open($csv_file+'.csv', 'ab') do |csv|
      csv << [x['id'],x['links']['learner']['id']]
    end
  end
end

puts 'Finished retrieving User and Enrollment IDs.'
sleep(1)
system('cls')

puts 'The program will now close.'
sleep(1)


