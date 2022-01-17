require 'open-uri'
require 'nokogiri'
require 'csv'

class Parser
  def initialize url, file_name
    @url = url
    @file = file_name + ".csv"
  end

  def categ_prod
    html = open(@url)
    document = Nokogiri::HTML(html)
    names = []
    a = 0

    document.xpath('//*/div[@class="product-desc display_sd"]').each do |row|
      tempName = row.search('a/@href').text.strip
      names << tempName
    end
    puts "I found #{names.count} type products"

  # Цикл переборки ссылок на товары
    for link in names do
      html = open(link)
      document = Nokogiri::HTML(html)


  # Определение симмвола по которому будет разделятся вес
      weight = document.xpath('//*/span[@class="radio_label"]').text.split(' ')
      symb = weight[-1]
      if (weight[-1]).nil?  || (weight[-1]).include?("0")
          symb = " "
      end

  # Информация о тоаре
      name = document.xpath('//h1[@class="product_main_name"]').text.lstrip
      weight = document.xpath('//*/span[@class="radio_label"]').text.split(symb)
      price = document.xpath('//*/span[@class="price_comb"]').text.split('€')
      image = document.xpath('//*/span[@id="view_full_size"]/img/@src').text.lstrip

  # Количество категорий товара
      num = weight.count

  # Запись в файл
      File.open(@file, 'a') do |csv|
        for i in (0..num-1) do
          weight_one = weight[i]
          if (weight[i]).nil?
              weight_one = " "
          end
          product_name = name + " - " + weight_one + symb
          csv << [product_name, price[i], image]
          csv << "\n"
        end
      end
      puts "Add #{a+=1} product"
    end
    puts "The data was writed into #{@file}"
  end
end
