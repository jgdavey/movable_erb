%w{rubygems sinatra erb lib/movable_erb}.each { |lib| require lib }

set :root, File.expand_path(File.dirname(__FILE__) + '/..')

get '/' do
  erb :index
end

post '/' do
  content_type "text/plain"
  MovableErb.new(:csv => params[:file][:tempfile].path).convert
end
