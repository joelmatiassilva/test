require 'sinatra'
require 'fusion_tables'
require "google_drive"
require "thin"
require 'httparty'

get '/' do
 erb :form
end


post '/form' do  
 
  response = HTTParty.get("http://ws.usig.buenosaires.gob.ar/rest/convertir_coordenadas?x=#{params[:longitud]}&y=#{params[:latitud]}&output=lonlat")
  latitud = response.parsed_response['resultado']['x']
  longitud = response.parsed_response['resultado']['y']
  coordenadas = longitud + ", "+ latitud  
  puts response
  puts coordenadas
  session = GoogleDrive.login("contacto@lanestorvive.org", "soloyolase")
  puts session
  tmpfile = params[:file][:tempfile]
  foto = session.upload_from_file(tmpfile, params[:file][:filename].to_s, :convert => false)
  url_foto = "https://googledrive.com/host/" + foto.resource_id.gsub("file:", '')
  root = session.root_collection
  collection = root.subcollection_by_title("FotosProblemasCiudad")
	collection.add(foto)
	root.remove(foto)

  ft = GData::Client::FusionTables.new      
  ft.clientlogin('contacto@lanestorvive.org', 'soloyolase') 
  ft.set_api_key('AIzaSyBbQFCNlmnjpwYtGKMOU6I522e0rP1XqZY') # obtained from the google api console
  ft.execute "INSERT INTO 15nwq3vUOnMwxqnH8LSMVyWu3YsH0aIBck2b2No0 (tipoDeProblema, descripcion, direccion, coordenadas, fecha, urlMedia) VALUES ('#{params[:tipoDeProblema]}', '#{params[:descripcion]}', '#{params[:direccion]}', '" + coordenadas +  "', '#{params[:fecha]}', '"+ url_foto +"');"
   puts ft
   erb :form
end  
