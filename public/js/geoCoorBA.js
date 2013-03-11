	$(document).ready(function() {
		
		var ac = new usig.AutoCompleter('direccion', {
       		onReady: function() {
       			$('#direccion').val('').removeAttr('disabled').focus();	        			
       		},
       		afterGeoCoding: function(pt) {
    			if (pt instanceof usig.Punto) {
    			  $('#longitud').val(pt.lon);
    			  $('#latitud').val(pt.lat);
    			}       			
       		}
       	});
				      
	});
