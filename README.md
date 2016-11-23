# 日本商業規模マップ用データ作成ツール
※個人的に使用するためのツールです。

## 本ツールの目的
[経済産業省の平成26年商業統計](http://www.meti.go.jp/statistics/tyo/syougyo/result-2.html)の[立地環境特性別統計編（小売業）内の第 10 表](http://www.meti.go.jp/statistics/tyo/syougyo/result-2/h26/index-ricchidata.html)を利用して日本国内における年の小売の商業規模を視覚的に表すマップを作成したい。そのためのデータをエクセルファイルから抽出し、データベースに格納するための SQL を作成するためのツールである。

統計のデータは商業集積地区の名称は含むがその住所についてのデータは含まないため、Google Map API を利用して、地区名称から座標データを取得する。

## ツールの使用方法
使用例）
```
ruby progmra.rb --file ./downtowns.csv --apikey xxxxxxxxxxxxxxxxxxxxxxxxxx'
```

<dl>
  <dt>--file</dt>
  <dd>（必須）インプット情報として使用する CSV ファイルのパスを指定します。</dd>
  <dt>--apikey</dt>
  <dd>（必須）Google Map API に接続するための API キーを指定します。</dd>
</dl>

### --file で指定するインプットファイルについて
[立地環境特性別統計編（小売業）内の第 10 表](http://www.meti.go.jp/statistics/tyo/syougyo/result-2/h26/index-ricchidata.html)から加工して作成する必要があります。

- ヘッダーあり。
- 以下の項目を持つ。

|順序|ヘッダー|内容|
|-----|----------|----------|
|1|prefecture_code|都道府県コード|
|2|code1|商業集積地コード1（コード体系不明）|
|3|code2|商業集積地コード2（コード体系不明）|
|4|name|商店街名|
|5|commercial_accumulation_code|集積細分コード|
|6|office_count|事業所数|
|7|inside_shop_count|大規模小売店舗内事業所数|
|8|employee_count|従業者数|
|9|annual_sales_turnover|年間商品販売額|
|10|area|売り場面積|

## TODO
- [x] 入力ファイルと API キーをコマンドライン引数から取得する。
- [x] CSV ファイルを読み込む。
- [ ] Google Map API に接続し、地名から座標を取得する。
- [ ] SQL 文を構築する。
- [ ] データベースに格納できるかのテストを記述する。