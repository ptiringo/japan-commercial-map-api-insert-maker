require 'csv'
require 'json'
require 'optparse'
require 'faraday'

options = ARGV.getopts('', 'file:', 'apikey:')

# オプションは必須
if options['file'].nil? or options['apikey'].nil? then
  puts 'ex) ruby progmra.rb --file ./downtowns.csv --apikey xxxxxxxxxxxxxxxxxxxxxxxxxx'
  exit 1
end

conn = Faraday.new(:url => 'https://maps.googleapis.com') do |faraday|
  faraday.request  :url_encoded
  faraday.adapter  Faraday.default_adapter
end

CSV.foreach(options['file'], headers: true) do |row|
  response = conn.get '/maps/api/geocode/json', { :address => row['name'], :key => options['key'] }

  body = JSON.parse(response.body)

  if body["status"] == "OK" then
    location = body["results"][0]["geometry"]["location"]
    latitude = location["lat"]
    longitude = location["lng"]
  else
    latitude = 0
    longitude = 0
  end

  puts <<~EOS
    INSERT INTO Downtown
    (
      prefecture_code,
      code1,
      code2,
      name,
      commercial_accumulation_code,
      office_count,
      inside_shop_count,
      employee_count,
      annual_sales_turnover,
      area,
      latitude,
      longitude
    )
    VALUES
    (
      #{row['prefecture_code']},
      #{row['code1']},
      #{row['code2']},
      '#{row['name']}',
      #{row['commercial_accumulation_code']},
      #{row['office_count']},
      #{row['inside_shop_count']},
      #{row['employee_count']},
      #{row['annual_sales_turnover']},
      #{row['area']},
      #{latitude},
      #{longitude}
    );
  EOS

  # 短時間での大量アクセスを避けるため少し時間を置く
  sleep(0.5)
end
