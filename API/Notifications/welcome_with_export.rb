#=============
# Bridge LMS - Unsupported Implementation Script
# Michael A. Valadez
# 11.13.16
# Send Welcome Invite To All Users - Generates CSV containing welcomed IDs.
#=============
require 'csv'
require 'unirest'
require 'rubygems'
require 'json'
require 'httparty'
require 'highline/import'

#------------------Replace these values-----------------------------#

$access_token = 'nil' # place your basic token between '' marks
$bridge_domain = 'nil' # place your Bridge domain between '' marks
$csv_file = 'nil' # file path where to export CSV

#-------------------Do not edit below this line---------------------#

unless $bridge_domain
  puts "What is your Bridge domain?\nNote: Only the domain is needed.\b"
  $bridge_domain = gets.chomp
end

unless $csv_file
  puts "What should I name your CSV file?\b"
  $csv_file = gets.chomp
end

puts 'retrieving user_ids from '+$bridge_domain
puts 'exporting user_ids to ' +$csv_file+'.csv'


class Get_User_ID

  headers = {'Authorization' => 'Basic '+$access_token, 'Content-Type' => 'application/json', 'Accept' =>
      'application/json'}

  $usr_url = 'https://'+$bridge_domain+'.bridgeapp.com/api/author/users?limit=1000'
  $welcome_url = 'https://'+$bridge_domain+'.bridgeapp.com/api/author/notifications/'

  response = HTTParty.get($usr_url, :headers => headers)
  json = JSON.parse(response.body)['users']

  json.each do |x|
    CSV.open($csv_file+'.csv', "ab") do |csv|
      csv << [x['id']]
    end
  end
end


class Welcome_Invitation

  bridge_user_id = Array.new
  CSV.foreach($csv_file+'.csv') do |row|
    bridge_user_id << row[0]
  end

  bridge_user_id.each { |x| Unirest.post("https://#{$bridge_domain}.bridgeapp.com/api/notifications/#{x}/welcome", headers:{ 'Authorization' => 'Basic '+$access_token,'Content-Type' => 'application/json', 'Accept' => 'application/json' }) }
  puts 'Successfully sent welcome emails to users.'

end
