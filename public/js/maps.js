   var map;
    var layerl0;
    var layerl1;
    function initialize() {
      map = new google.maps.Map(document.getElementById('map-canvas'), {
        center: new google.maps.LatLng(-34.59592945293611, -58.39270492828373),
        zoom: 10,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      });

      layerl0 = new google.maps.FusionTablesLayer({
        query: {
          select: "'col2'",
          from: '1_7jbbcPLV7HlYtSGQOgKO7d7677u2tulkVG54Ig'
        },
        map: map,
        styleId: 2,
        templateId: 2
      });

      layerl1 = new google.maps.FusionTablesLayer({
        query: {
          select: "'col5'",
          from: '15nwq3vUOnMwxqnH8LSMVyWu3YsH0aIBck2b2No0',
          where: 'habilitado = 1' 
        },
        map: map,
        styleId: 2,
        templateId: 3
      });
      
    }
    google.maps.event.addDomListener(window, 'load', initialize);
