require 'sinatra'
require './core'
require './helpers'
require 'tempfile'

configure :development do |config|
  require 'sinatra/reloader'
  config.also_reload "*.rb"
end

get '/' do
  @messages = Message.all
  erb :messages
end

get '/messages/:id/attachments/:name' do
  message = Message.find(params[:id]).first
  attachment = message.find_attachment(params[:name])
  content_type attachment['content_type']
  file = Tempfile.new(attachment['name'])
  file.write(Base64.decode64(attachment['data']))
  send_file file.path
end

get '*.js' do
  content_type "application/javascript"
  File.read( File.join(File.dirname(__FILE__), 'script', params[:splat].join('/') << '.js') )
end

get '*.css' do
  content_type 'text/css'
  sass params[:splat].join('').to_sym
end

