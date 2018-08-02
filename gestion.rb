require 'rubygems'
require 'sinatra'
require 'data_mapper'
DataMapper.setup(:default, 'sqlite:db/development.db')
DataMapper::Logger.new($stdout, :debug)

class Client
  include DataMapper::Resource
  property :id, Serial
  property :nombre, String
  property :apellido, String
  property :dni, String
  property :fecha_nac, String
  property :sexo, String
  property :telefono, String
  property :direccion, String
  property :ciudad, String

  # belongs_to :alquiler
end

# class Alquiler
#   include DataMapper::Resource
#   property :id, Serial
#   property :created_at, DateTime
#   property :fecha_devolucion, String
#   property :estado, String
#
#   has 1, :client
#   has 1, :book
# end
#
# class Book
#   include DataMapper::Resource
#   property :id, Serial
#   property :titulo, String
#   property :autor, String
#   property :anio_publicacion, Integer
#   property :edicion, String
#   property :estado, String
#
#   belongs_to :alquiler
# end


DataMapper.auto_upgrade!

#--------------------------------------------------------
# Index

get '/' do
  # @client = Client.all
  slim :index
end


#--------Client new--------------------------------
get '/client/new' do
  slim :client_new
end

post '/client/new' do
  client= Client.new(nombre: params[:nombre], apellido: params[:apellido], dni: params[:dni], fecha_nac: params[:fecha_nac], sexo: params[:sexo], telefono: params[:telefono], direccion: params[:direccion], ciudad: params[:ciudad])
  if client.save!
    redirect "/client/ver/#{client.id}"
  else
    p 'Algo salio mal'
  end
end

#--------Client edit-----------------------------

get '/client/edit/:id' do
  @client = Client.get(params[:id])
  slim :client_edit
end

post 'client/edit/:id' do
  @client = Client.get(params[:id])
  @client.nombre=params[:nombre]
  @client.apellido=params[:apellido]
  @client.dni=params[:dni]
  @client.fecha_nac=params[:fecha_nac]
  @client.sexo=params[:sexo]
  @client.telefono=params[:telefono]
  @client.direccion=params[:direccion]
  @client.ciudad=params[:ciudad]
  @client.save
  slim :client_edit
end

#--------Client all----------------------------

get '/client/all' do
  @client = Client.all
  slim :clients
end

#-------Client ver----------------------------

get '/client/ver/:id' do
  @client = Client.get(params[:id])
  slim :client
end

#-------Client delete------------------------

get '/client/ver/:id/delete' do
  @client = Client.get(params[:id])
  @client.destroy
  redirect '/client/all'
end

#---------------------------------------------------------


#//////////////////////////////////////////////////////////////////////////////

# Alquileres

#.......Alquiler new----------------------
#
# get '/client/:id/alquiler/new' do
#   @client = Client.get(params[:id])
#   # @book= Book.all();
#   slim :alquiler_new
# end
#
# post '/client/:id/alquiler/new' do
#   client = Client.get(params[:id])
#   alquiler = client.alquilers.new(created_at: Time.now, fecha_devolucion: params[:fecha_devolucion])
#   if alquiler.save
#     redirect "client/#{client.id}/alquiler/#{alquiler.id}"
#   else
#     p 'error'
#   end
# end
#
# get 'client/:client_id/alquiler/:id' do
#   client = Client.get(params[:client_id])
#   @alquiler = client.alquiler.get(params[:id])
#   slim :alquiler
# end
#


#-------Alquiler edit-------------------
#
# get '/alquiler/edit' do
#   @alquiler=Alquiler.get(params[:id])
#   slim :alquiler_edit
# end
#
# post 'alquiler/edit/:id' do
#   @alquiler = Alquiler.get(params[:id])
#   @alquiler.nombre=params[:dni]
#   @alquiler.titulo=params[:titulo]
#   @alquiler.anio_publicacion=params[:anio_publicacion]
#   @alquiler.save
#   slim :alquiler_edit
# end
#
# #........Alquiler all-------------------
#
# get '/alquiler/all' do
#   @alquiler = Alquiler.all
#   slim :alquilers
# end
#
# #-------Alquiler ver-------------------
#
# get '/alquiler/ver/:id' do
#   @alquiler = Alquiler.get(params[:id])
#   slim :alquiler
# end
#
# #------Alquiler delete---------------
#
# get '/alquiler/ver/:id/delete' do
#   @alquiler = Alquiler.get(params[:id])
#   @alquiler.destroy
#   redirect '/alquiler/all'
# end

#////////////////////////////////////////////////////////////////////

# Books

#-------Book new------------------------------------

# get '/book/new' do
#   slim :book_new
# end
#
# post '/book/new' do
#   book= Book.new(titulo: params[:titulo], autor: params[:autor], anio_publicacion: params[:anio_publicacion], edicion: params[:edicion], estado: params[:estado])
#   if book.save!
#     redirect "/book/ver/#{book.id}"
#   else
#     p book.errors
#   end
# end
#
# #------Book edit----------------------------------
#
# get '/book/edit/id' do
#   @book = Book.get(params[:id])
#   slim :book_edit
# end
#
# post '/book/edit/:id' do
#   @book=Book.get(params[:id])
#   @book.titulo=params[:titulo]
#   @book.autor=params[:autor]
#   @book.anio_publicacion=params[:anio_publicacion]
#   @book.edicion=params[:edicion]
#   @book.estado=params[:estado]
#   @book.save
#   slim :book_edit
# end
#
# #------Book all----------------------------------
#
# get '/book/all' do
#   @books = Book.all
#   slim :books
# end
#
# #------Book ver---------------------------------
#
# get '/book/ver/:id' do
#     @book = Book.get(params[:id])
#     slim :book
# end
#
# #-----Book delete------------------------------
#
# get '/book/ver/:id/delete' do
#   @book = Book.get(params[:id])
#   @book.destroy
#   redirect '/book/all'
# end

#//////////////////////////////////////////////////////////////////////////////

# Clients (Ususarios)

# get '/delete/:id' do
#   @client = Client.get(params[:id])
#   @client.destroy
#   redirect '/'
# end
#
# post 'client/editar/:id' do
#   @client = Client.get(params[:id])
#   @client.nombre=params[:nombre]
#   @client.division=params[:division]
#   @client.anio_lectivo=params[:anio_lectivo]
#   @client.save
#   slim :client_edit
# end

# post '/client/nuevo' do
#   client= Client.new(nombre: params[:nombre], division: params[:division], anio_lectivo: params[:anio_lectivo])
#   if client.save!
#     redirect "/client/ver/#{client.id}"
#   else
#     p 'Algo salio mal'
#   end
# end

run Sinatra::Application.run!
