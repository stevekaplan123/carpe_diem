  //function that automatically refreshes page
     (function()
    {
      if( window.localStorage )
      {
        if( !localStorage.getItem( 'firstLoad' ) )
        {
          localStorage[ 'firstLoad' ] = true;
          window.location.reload();
        }  
        else
          localStorage.removeItem( 'firstLoad' );
      }
    })();

    var marker = null;
    var map = null;

    
    function markMe(latitude, longitude)
    {
        me_window = new google.maps.InfoWindow({
            content: "You are here",
            position: new google.maps.LatLng(latitude, longitude),
         });

        me_window.open(gMap);
    }


    //gets called by geolocation attempt with position of user
    function showPosition(position) {
           var str_loc = position.coords.latitude + ", " + position.coords.longitude;
           var loc = str_loc.split(", "); 
           var latitude = loc[0]
           var longitude = loc[1]
           markMe(latitude, longitude)
    }


    $(function(){
        document.getElementById("event_latitude").style.visibility = "hidden";
        document.getElementById("event_longitude").style.visibility = "hidden";
        document.getElementById("event_location").style.visibility="hidden";

        //set up map centered at brandeis
        var myOptions = {
            center: new google.maps.LatLng(42.3654347, -71.258595),
            zoom: 15,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        gMap = new google.maps.Map(document.getElementById('map_canvas'), myOptions);
  	   
        //find geolocation of user
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(showPosition); 

        } else { 
            myDiv.innerHTML = "Geolocation is not supported by this browser.";
        }


        //allow for user to click a different spot on map, thus changing event's lat and lng
        google.maps.event.addListener(gMap, 'click', function(event) {
            if (marker != null)
            {
              marker.setMap(null);
            }
            marker = new google.maps.Marker({
                position: event.latLng,
                map: gMap
            });
            document.getElementById("event_latitude").value = event.latLng.lat()
            document.getElementById("event_longitude").value = event.latLng.lng()


        });

    });
