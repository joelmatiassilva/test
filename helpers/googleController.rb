# encoding: utf-8
require 'sinatra/base'

module GoogleController

  def createNewPhotoInGD
    session = GoogleDrive.login("contacto@lanestorvive.org", "soloyolase")
    temporal = tmpfile
    foto = session.upload_from_file(temporal, fileName, :convert => false)
    url_foto = "https://googledrive.com/host/" + foto.resource_id.gsub("file:", '')
    root = session.root_collection
    collection = root.subcollection_by_title("FotosProblemasCiudad")
	  collection.add(foto)
	  root.remove(foto)
  end

  def createRowInFT
    ft = GData::Client::FusionTables.new      
    ft.clientlogin('contacto@lanestorvive.org', 'soloyolase') 
    ft.set_api_key('AIzaSyBbQFCNlmnjpwYtGKMOU6I522e0rP1XqZY') # obtained from the google api console
    ft.execute "INSERT INTO 15nwq3vUOnMwxqnH8LSMVyWu3YsH0aIBck2b2No0 
    (tipoDeProblema, descripcion, direccion, coordenadas, fecha, urlMedia, email, urlVideo) VALUES ('#{tipoDeProblema}', '#{descripcion}', '#{direccion}', '#{coordenadas}', '#{fecha}', '#{url_foto}', '#{email}', '#{video}');"
  end

  def test()
    puts 'testssss'
  end  
  module_function :test
end
