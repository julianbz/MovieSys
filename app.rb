#proy final

require 'rubygems'
require 'slim'
require 'sinatra'
require 'data_mapper'
DataMapper.setup(:default, 'sqlite:db/development.db')
DataMapper::Logger.new($stdout, :debug)
enable :sessions


class Category
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :movies
  has n, :comments, through: :movies
end

class Movie
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :director, String
  property :year, String
  property :image, String
  property :description, String
  property :created_at, DateTime

  belongs_to :category
  has n, :comments
end

class Comment
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :comment, String
  property :created_at, DateTime

  belongs_to :movie
end


DataMapper.auto_upgrade!

#--------------------------------------------------------
# Index All movies

get '/' do
  @categories = Category.all
  @lasts_movies = @categories.movies.all
  slim :index
end

get '/lasts_movies' do
  @categories = Category.all
  @lasts_movies = @categories.movies.all(:limit => 5, :order => [ :created_at.desc ])
  slim :lasts_movies
end

get '/lasts_comments' do
  @categories = Category.all
  @movies = @categories.movies.all

  @lasts_comments = @categories.movies.comments.all(:limit => 10, :order => [ :created_at.desc ])

  slim :lasts_comments
end


#--------Category new--------------------------------

get '/category_new' do
  @categories = Category.all
  slim :category_new
end

post '/category_new' do
  p "hola"
  category= Category.new(name: params[:name])
  if category.save!
    redirect "/"
  else
    p 'Algo salio mal al crear una categoria'
  end
end

#--------Category show--------------------------------

get '/category/:id' do
  @categories = Category.all
  @category = Category.get(params[:id])
  @movies = @category.movies.all

  slim :category
end

#--------Category edit--------------------------------------------

get '/category/:id/edit' do
  @categories = Category.all
  @category = Category.get(params[:id])
  slim :category_edit
end

post '/category/:id/edit' do
  @category = Category.get(params[:id])
  @category.name=params[:name]
  @category.save
  redirect "/category/#{@category.id}"
end
#-------Category delete------------------------------------------

get '/category/:id/delete' do
  @category = Category.get(params[:id])
  @category.destroy
  redirect '/'
end

#---------------------------------------------------------

#//////////////////////////////////////////////////////////////////////////////

# Movies

# .......Movie new----------------------

get '/category/:id/movie_new' do
  @categories = Category.all
  @category = Category.get(params[:id])
  slim :movie_new
end

post '/category/:id/movie_new' do
  category = Category.get(params[:id])
  movie = category.movies.new(created_at: Time.now, name: params[:name], year: params[:year], director: params[:director], description: params[:description],image: params[:image])
  if movie.save!
    redirect "/category/#{category.id}"
  else
    p 'error'
  end
end

# .......Movie show----------------------

get '/category/:id/movie/:id_m' do
  @categories = Category.all
  category = Category.get(params[:id])
  @movie = category.movies.get(params[:id_m])
  slim :movie
end

# .......Movie edit----------------------

get '/category/:category_id/movie/:movie_id/edit' do
  @categories = Category.all

  @category = Category.get(params[:category_id])
  @movie = @category.movies.get(params[:movie_id])
  slim :movie_edit
end

post '/category/:id/movie/:id_m/edit' do
    @category = Category.get(params[:id])
    @movie = @category.movies.get(params[:id_m])

    @movie.name=params[:name]
    @movie.year=params[:year]
    @movie.director=params[:director]
    @movie.description=params[:description]
    @movie.image=params[:image]
    if @movie.save!
      redirect "/category/#{@category.id}/movie/#{@movie.id}"
    else
      p 'algo salio mal'
    end
end

#-------Movie delete------------------------------------------

get '/category/:category_id/movie/:movie_id/delete' do
  category = Category.get(params[:category_id])
  movie = category.movies.get(params[:movie_id])
  movie.destroy
  redirect '/'
end

#------ Comment new -----------------------------------------

post '/category/:category_id/movie/:movie_id/comment_new' do
  category = Category.get(params[:category_id])
  movie = category.movies.get(params[:movie_id])
  comment = movie.comments.new(name: params[:name], comment: params[:comment], created_at: Time.now)
  if comment.save!
    redirect "/category/#{category.id}/movie/#{movie.id}"
  else
    redirect "/category/#{category.id}"
  end
end

#------ Comment delete----------------------------------------

get '/category/:category_id/movie/:movie_id/comment/:id/delete' do
  category = Category.get(params[:category_id])
  movie = category.movies.get(params[:movie_id])
  comment = movie.comments.get(params[:id])
  comment.destroy
  redirect "/category/#{category.id}/movie/#{movie.id}"
end

run Sinatra::Application.run!
