require 'csv'
require 'json'
require 'optparse'
require 'faraday'

options = ARGV.getopts('', 'input:', 'apikey:')

# オプションは必須
if options['input'].nil? || options['apikey'].nil?
  puts 'ex) ruby progmra.rb --input ./downtowns.csv --apikey xxxxxxxxxxxxx'
  exit 1
end

conn = Faraday.new(url: 'https://maps.googleapis.com') do |faraday|
  faraday.request :url_encoded
  faraday.adapter Faraday.default_adapter
end

File.open('insert.sql', 'w') do |file|
  CSV.foreach(options['input'], headers: true) do |row|
    response = conn.get '/maps/api/geocode/json',
                        address: row['name'],
                        key: options['apikey']

    body = JSON.parse(response.body)

    if body['status'] == 'OK'
      location = body['results'][0]['geometry']['location']
      latitude = location['lat']
      longitude = location['lng']
    else
      latitude = 0
      longitude = 0
    end

    file.puts <<~SQL
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

    SQL

    # 短時間での大量アクセスを避けるため少し時間を置く
    sleep(0.5)
  end

  file.puts 'COMMIT;'
end
