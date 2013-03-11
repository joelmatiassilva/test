//
//	jQuery Validate example script
//
//	Prepared by David Cochran
//
//	Free for your use -- No warranties, no guarantees!
//

$(document).ready(function(){
	  
  $.validator.addMethod("ValidarDireccion", 
  function(value, element) {
    if($("#longitud").val() == "" && $("#latitud").val()=="")
     return false;
    
    return true;

  },"La dirección tiene que ser la más certera posible.");
	// Validate
	// http://bassistance.de/jquery-plugins/jquery-plugin-validation/
	// http://docs.jquery.com/Plugins/Validation/
	// http://docs.jquery.com/Plugins/Validation/validate#toptions
		$('#problemBA').validate({
		  event: "blur",
	    rules: {
	      file: {
	        minlength: 2,
	        required: true
	        
	      },
	      direccion:{
	      	minlength: 1,
	      	required: true,
	      	ValidarDireccion: true,
	        remote: 
	        {
	              url: '/validateCoord',
	              type: 'get',
	        	    data: {
                  longitud: function() {
                    return $("#longitud").val();
                  },
                  latitud: function() {
                    return $("#latitud").val();
                  }
	              }
          },          
         video:{
          url:true
         },
         email:{
          email:true
         },         
         date:{
          date:true
         } 
	        
	      }
	    },
			highlight: function(element) {
				$(element).closest('.control-group').removeClass('success').addClass('error');
			},
			success: function(element) {
				element
				.text('OK!').addClass('valid')
				.closest('.control-group').removeClass('error').addClass('success');
			}
	  });


	  

}); // end document.ready
