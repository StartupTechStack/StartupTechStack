require 'sinatra'
require 'json'
require 'mongo/driver'

configure :development do
  set :bind, '192.168.33.98'
end

connection = Mongo::Connection.new
db = connection.StartupTechStack

def by_year(companies)
  by_year = {}
  companies.each do |c|
    if c["fundingEvent"]
      c["fundingEvent"].each do |event|
        by_year[event["year"]] ||= []
        by_year[event["year"]] << c.merge("amount" => event["amount"])
      end
    end
  end

  by_year
end

def by_stack(yearly)
  values = []
  yearly.each do |k, v|
    values << {
      year: k,
      count: v.count,
      stack: v.map{ |c| c['name'] }
    }
  end
  values.sort{ |a, b| a[:year] <=> b[:year] }
end

# Home page
get '/' do
  'Startup [Tech] Stack'
end

# Get all companies, and their data
get '/company' do
  companies = db.Company.all
  comp = {}
  companies.map{ |c| comp[c["name"]] = c }

  yearly = by_year(companies)

  {
    stack: by_stack(yearly),
    by_year: yearly,
    companies: comp
  }.to_json
end

# Get companies by category
get '/company/:category' do
  companies = db.Company.all(category: params[:category])
  {
    companies: companies
  }.to_json
end

# Get all funding summarized by category
get '/funding/categories' do

end

# Get all funding summarized by tech
get '/funding/tech' do

end
