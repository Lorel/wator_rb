require 'marsys'
require 'sinatra/base'
require 'json'
require 'slim'

load "agent.rb"
load "tuna.rb"
load "shark.rb"
load "core.rb"

class App < Sinatra::Base
	use Rack::Session::Pool
	set :public_folder, File.dirname(__FILE__) + '/../static'

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
			starving: 					params[:starving].to_i
		}
		session[:instance] = Core.new options
    content_type :json
		session[:instance].environment.to_json
	end

	get '/turn' do
		begin
	    session[:instance].environment.turn
	  rescue => error
	  	puts error.inspect
	  end

    content_type :json
    session[:instance].environment.to_json
	end

	get '/param/:id' do
		user_id = params[:id]
	end

	run! if app_file == $0 # run Sinatra
end
