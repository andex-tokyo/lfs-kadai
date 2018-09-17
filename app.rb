require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'
require 'dotenv/load'

enable :sessions

helpers do
    def current_user
      User.find_by(id: session[:user])
    end
end

before '/' do
    if current_user.nil?
        redirect '/signin'
    end
end

def image_upload(img)
  logger.info "upload now"
  tempfile = img[:tempfile]

  upload = Cloudinary::Uploader.upload(tempfile.path)

  contents = Count.last

  contents.update_attribute(:img, upload['url'])
end

get '/signup' do
    erb :signup
end

post '/signup' do
    user = User.create(
        name: params[:name],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
        )
    if user.persisted?
        session[:user] = user.id
    end
    redirect '/'
end

get '/signin' do
    erb :signin
end

post '/signin' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
    redirect '/'
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end

get "/" do
  @count = Count.all
  erb :index
end

get '/new' do
  erb :new
end

post "/new" do

    Count.create({
        title: params[:title],
        number: 0,
        img: "",
        main_counter: current_user.name
    })
    puts params
    if params[:file]
        image_upload(params[:file])
    end
    redirect "/"
end

get "/detail/:id" do
  @count = Count.find(params[:id])
  erb :detail
end

get "/count/:id" do
  count = Count.find(params[:id])
  count.number = count.number + 1
  count.save
  Counter.create({
    user_id: current_user.id,
    count_id: params[:id]
  })
  redirect "/"
end

get "/count_d/:id" do
  count = Count.find(params[:id])
  count.number = count.number + 1
  count.save
  Counter.create({
    user_id: current_user.id,
    count_id: params[:id]
  })
  redirect "/detail/#{params[:id]}"
end