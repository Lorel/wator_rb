
require 'sinatra/base'
require 'json'
require 'slim'

load "core.rb"

class App < Sinatra::Base

	get '/' do
		slim :index
	end

	get '/init/:size/:tuna_inhabitants/:shark_inhabitants/:tuna_breeding/:shark_breeding/:starving' do
		options = {
			dimensions: 				params[:size].to_i,
			tuna_inhabitants: 	params[:tuna_inhabitants].to_i,
			shark_inhabitants: 	params[:shark_inhabitants].to_i,
			tuna_breeding: 			params[:tuna_breeding].to_i,
			shark_breeding: 		params[:shark_breeding].to_i,
			starving: 					params[:starving]
		}
		@c = Core.new options
    content_type :json
		@c.environment.to_json
	end

	get '/turn' do
    @c ||= Core.new
    @c.environment.turn
    content_type :json
    @c.environment.to_json
	end

	get '/param/:id' do
		user_id = params[:id]
	end

	run! if app_file == $0 # run Sinatra
end
