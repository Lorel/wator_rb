require 'sinatra'
require 'json'

load "core.rb"

get '/' do
  content_type :json
  m = Environment.new
  m.to_json
end

get '/param/:id' do
    user_id = params[:id]
end