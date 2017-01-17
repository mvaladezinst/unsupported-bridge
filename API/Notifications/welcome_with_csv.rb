#=============
# Bridge LMS - Unsupported Implementation Script
# Michael A. Valadez
# 11.13.16
# Send Welcome Invite To CSV Defined Users
#=============

require 'csv'
require 'unirest'
require 'rubygems'
require 'json'
require 'typhoeus'
require 'HTTParty'

#==========================Replace these values========================#

# Either provide values at prompt, or provide values between '' marks and remove nil.

# API Token provided by IC or Bridge Support. Token value only! Do not include 'Basic'
$access_token = 'nil'

# Your Bridge domain. Do not include https://, or, bridgeapp.com.
$bridge_domain = 'nil'

# Location where you would like the CSV to be exported to. Leave blank to default to project folder.
$csv_file = 'nil'


#---------------------Do not edit below this line unless you know what you're doing-------------------#

unless $access_token
  puts 'What is your access token?'
  $access_token = gets.chomp
end

unless $bridge_domain
  puts 'What is your Bridge domain?'
  $domain = gets.chomp
end

unless $csv_file
  puts 'Where is your UID update CSV located?'
  $csv_file = gets.chomp
end

unless File.exists?($csv_file)
  raise "Error: can't locate the update CSV"
end

system('cls')

puts 'Testing user defined variables...'
sleep(1)
system('cls')

unless File.exists?($csv_file)
  raise 'Error: cannot locate the CSV file at the specified file path. Please correct this and run again.'
end

$base_url = "https://#{$bridge_domain}.bridgeapp.com/api/author"
$test_url = "#{$base_url}/course_templates"

# Make generic API call to test token, domain, and env.
$test = Typhoeus.get($test_url, headers: {'Content-Type'=>'application/json', 'accept'=>'application/json', 'Authorization'=>"Basic #{$access_token}"}
)

unless test.code == 200
  raise 'Error: The token or domain variables are not set correctly. Please correct this and run again.'
end

class SendInvites
CSV.foreach($csv_file, {:headers => true}) do |row|
  Typhoeus.post("#{$base_url}/notifications/#{row['user_id']}/welcome")
  puts "Welcome invite sent to user ID: #{row['user_id']}"
end

puts 'Finished sending welcoming invites.'

sleep(1)
system('cls')

puts 'The program will now close.'
sleep(1)

end
