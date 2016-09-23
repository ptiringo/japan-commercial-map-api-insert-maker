require 'csv'

id = 0

CSV.foreach('./downtowns.csv', headers: true) do |row|
    id += 1
    puts <<~EOS
    "INSERT INTO Downtown
    (
      id,
      prefecture_code,
      code1,
      code2,
      name,
      commercial_accumulation_code,
      office_count,
      inside_shop_count,
      employee_count,
      annual_sales_turnover,
      area
    )
    VALUES
    (
      #{id},
      #{row['prefecture_code']},
      #{row['code1']},
      #{row['code2']},
      '#{row['name']}',
      #{row['commercial_accumulation_code']},
      #{row['office_count']},
      #{row['inside_shop_count']},
      #{row['employee_count']},
      #{row['annual_sales_turnover']},
      #{row['area']}
    );
    EOS
end
