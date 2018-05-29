require 'net/http'
require 'json'
require 'pry'


def get_json(month)
  uri = URI("https://api.nytimes.com/svc/archive/v1/1940/#{month}.json")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  uri.query = URI.encode_www_form({
    "api-key" => "67212b6ceb4c46e28fb30b9be4186499"
  })
  request = Net::HTTP::Get.new(uri.request_uri)
  JSON.parse(http.request(request).body)
end

def get_articles_for_month(month)
  results = []
  month_json = get_json(month)
  month_json["response"]["docs"].each do |article|
    results << article
  end
  results
end

def get_articles_for_year
  i = 1
  results = []
  while i <= 12
    results.concat(get_articles_for_month(i))
    i += 1
  end
  binding.pry
end

def get_keyword
  puts "Please enter a keyword: "
  gets.chomp.downcase
end

def filter_results_for_keyword(results)
  keyword = get_keyword
  filtered_results = results.select do |article|
    article["headline"]["main"].downcase.include?(keyword)
  end
end

def get_result_headlines(filtered_results)
  result_headlines = filtered_results.map do |article|
    article["headline"]["main"]
  end
end

results = get_articles_for_month(2)
filtered_results = filter_results_for_keyword(results)
filtered_headlines = get_result_headlines(filtered_results)
binding.pry
