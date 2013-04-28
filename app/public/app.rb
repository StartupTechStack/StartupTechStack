require 'sinatra'
require 'json'
require 'mongo/driver'

configure :development do
  set :bind, '192.168.33.98'
end

connection = Mongo::Connection.new
db = connection.startuptechstack

# Home page
get '/' do
  'Startup [Tech] Stack'
end

# Get all companies, and their data
get '/companies' do
  companies = db.companies.all
  companies.to_json
end

# Get companies by category
get '/companies/:category' do
  companies = db.companies.by_category(params[:category])
  companies.to_json
end

# Get all funding summarized by category
get '/funding/categories' do

end

# Get all funding summarized by tech
get '/funding/tech' do

end
