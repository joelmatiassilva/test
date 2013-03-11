require 'sinatra'
require 'thin'
require 'fusion_tables'
require "google_drive"
require 'httparty'
require_relative 'helpers/googleController'
require_relative 'helpers/validate'




get '/' do
 erb :form
end

get '/validateCoord' do
  #coordenadas
  
  _coordLongitud = params[:longitud]
  _coordLatitud = params[:latitud]
  
  puts _coordLongitud
  puts _coordLatitud
  
    coordLongitud  = _coordLongitud  #verificiar que no sea html o vacio
  coordLatitud = _coordLatitud  #verificar que no sea html o vacio
  
  response = HTTParty.get("http://ws.usig.buenosaires.gob.ar/rest/convertir_coordenadas?x=#{coordLongitud}&y=#{coordLatitud}&output=lonlat")
  latitud = response.parsed_response['resultado']['x']
  longitud = response.parsed_response['resultado']['y']
  coordenadas = longitud + ", "+ latitud  
  puts coordenadas
  if coordenadas == ", "
  'false'
  else
   'true'
  end 
end

post '/form' do    
  if !Validate.hasErrorUploadFile?(params[:file])
      puts params[:date].to_s
      hsh = { :tipoDeProblema => params[:tipoDeProblema], \
              :direccion => params[:direccion], \
              :fecha => params[:date].to_s, \
              :coordLongitud => params[:longitud], \
              :coordLatitud => params[:latitud]
            }
            
      if !(Validate.hasEmptyFields?(hsh).length > 0)     
     
           #tomarParametros
          _tipoDeProblema = params[:tipoDeProblema]
          _direccion = params[:direccion]
          _descripcion = params[:descripcion]
          _fecha = params[:date]
          _coordLongitud = params[:longitud]
          _coordLatitud = params[:latitud]
          _tmpfile = params[:file][:tempfile]
          _fileName = params[:file][:filename].to_s
          _email = params[:email]
          _video = params[:video]
         
          #validaciones
          tipoDeProblema = _tipoDeProblema#verificar que no sea html
          descripcion = _descripcion #verificar q no sea html
          direccion = _direccion #verificar que no sea html o vacio
          fecha = _fecha #verificar que no sea html
          coordLongitud  = _coordLongitud  #verificiar que no sea html o vacio
          coordLatitud = _coordLatitud  #verificar que no sea html o vacio
          tmpfile = _tmpfile #verificar que no sea html o vacio
          fileName = _fileName #verificar que no sea html o vacio
          email = _email #verificar q sea email
          video = _video
          fecha = _fecha 
          
          puts fecha
          
          
          puts 'paso validaciones'
          #coordenadas
          response = HTTParty.get("http://ws.usig.buenosaires.gob.ar/rest/convertir_coordenadas?x=#{coordLongitud}&y=#{coordLatitud}&output=lonlat")
          latitud = response.parsed_response['resultado']['x']
          longitud = response.parsed_response['resultado']['y']
          coordenadas = longitud + ", "+ latitud  
          puts 'paso coordenadas'
          
          #fotos
          session = GoogleDrive.login("", "")
          temporal = tmpfile
          foto = session.upload_from_file(temporal, fileName, :convert => false)
          url_foto = "https://googledrive.com/host/" + foto.resource_id.gsub("file:", '')
          root = session.root_collection
          collection = root.subcollection_by_title("FotosProblemasCiudad")
	        collection.add(foto)
	        root.remove(foto)
          puts 'paso fotos'


          #fusion table
          ft = GData::Client::FusionTables.new      
          ft.clientlogin('', '') 
          ft.set_api_key('') # obtained from the google api console
          ft.execute "INSERT INTO 15nwq3vUOnMwxqnH8LSMVyWu3YsH0aIBck2b2No0 
          (tipoDeProblema, descripcion, direccion, coordenadas, fecha, urlMedia, email, urlVideo, habilitado) VALUES ('#{tipoDeProblema}', '#{descripcion}', '#{direccion}', '#{coordenadas}', '#{fecha}', '#{url_foto}', '#{email}', '#{video}', 0);"
          puts 'paso fusion tables'
      else
        @variable='hola2'
        erb :"/form"
      end  
  else
      @variable='hola'
      erb :"/form"
  end
 
end  
