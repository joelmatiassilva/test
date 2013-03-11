module Validate

  def hasErrorUploadFile?(file)
    unless file && (tmpfile = file[:tempfile]) && (name = file[:filename])
      return true 
    end
    return false
  end
  module_function :hasErrorUploadFile?
    
  def hasEmptyFields?(listFields)
    listEmptyFields = {} 
    listFields.each do |variable|
      puts "valor #{variable[0]}"
      if variable[1].empty? 
        listEmptyFields[variable[0]] = 1
      end
    end
    puts listEmptyFields
    return listEmptyFields
  end
  module_function :hasEmptyFields?

end
