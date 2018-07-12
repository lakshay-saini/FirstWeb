<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>

    <script async defer
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBTtk3MxfUwwYG7VZln5To3aEc0n7PpFAs&callback=initMap"></script>
    <script src="https://maps.googleapis.com/maps/api/js?sensor=false&libraries=places"></script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>


    <style>

        input[type=text], select {
            width: 100%;
            padding: 12px 20px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        button {
            display: inline-block;
            padding: 5px 5px;
            font-size: 24px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            outline: none;
            color: #fff;
            background-color: teal;
            border: none;
            border-radius: 15px;
            box-shadow: 0 3px #999;
        }

        button:hover {background-color: teal}

        button:active {
            background-color: teal;
            box-shadow: 0 3px #666;
            transform: translateY(4px);
        }
    </style>
    <title>Welcome to Locato</title>
</head>

<body>

<div class="form_area">

    <div class="map" id="map" style="width: 100%; height: 400px;"></div>

    <div id="submitForm">
        <input type="text" name="location" id="location" readonly><br>

        <input type="text" name="lat" id="lat" readonly><br>

        <input type="text" name="lng" id="lng" alt="longitude" readonly><br>
    </div>

    <button id="Save" onclick="doSaveAjax();">Save</button>

    <button id="Display" onclick="doShowAjax();">Display</button>
</div>

<script>
    function doShowAjax() {
        $.ajax({
            type: "GET",
            url: "<c:url value="/Display"/>",
            success: function (response) {
                $('.form_area').html(response);
                },
            error: function (e) {
                alert('Error: ' + e);
            }
        });
    }
</script>

<script>
    function doSaveAjax() {
        var location = $('#location').val();
        var lat = $('#lat').val();
        var lng = $("#lng").val();

        var data = {
            address: location,
            longitude: lng,
            latitude: lat
        };

        $.ajax({
            type: "GET",
            url: "<c:url value="/AddLocation"/>",
            data: data,
            success: function (response) {
                alert(response);
                $('#location').val('');
                $('#lat').val('');
                $('#lng').val('')
            },
            error: function (e) {
                alert('Error: ' + e);
            }
        });
    }
</script>

<script>
    function initialize() {
        var latlng = new google.maps.LatLng(27.700007 , 74.466693);
        var map = new google.maps.Map(document.getElementById('map'), {
            center: latlng,
            zoom: 13
        });
        var marker = new google.maps.Marker({
            map: map,
            position: latlng,
            draggable: true,
            anchorPoint: new google.maps.Point(0, -29)
        });
        var input = document.getElementById('searchInput');
        map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
        var geocoder = new google.maps.Geocoder();
        var autocomplete = new google.maps.places.Autocomplete(input);
        autocomplete.bindTo('bounds', map);
        var infowindow = new google.maps.InfoWindow();
        autocomplete.addListener('place_changed', function () {
            infowindow.close();
            marker.setVisible(false);
            var place = autocomplete.getPlace();
            if (!place.geometry) {
                window.alert("Autocomplete's returned place contains no geometry");
                return;
            }

            if (place.geometry.viewport) {
                map.fitBounds(place.geometry.viewport);
            } else {
                map.setCenter(place.geometry.location);
                map.setZoom(17);
            }

            marker.setPosition(place.geometry.location);
            marker.setVisible(true);

            bindDataToForm(place.formatted_address, place.geometry.location.lat(), place.geometry.location.lng());
            infowindow.setContent(place.formatted_address);
            infowindow.open(map, marker);

        });
        google.maps.event.addListener(marker, 'dragend', function () {
            geocoder.geocode({'latLng': marker.getPosition()}, function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    if (results[0]) {
                        bindDataToForm(results[0].formatted_address, marker.getPosition().lat(), marker.getPosition().lng());
                        infowindow.setContent(results[0].formatted_address);
                        infowindow.open(map, marker);
                    }
                }
            });
        });
    }

    function bindDataToForm(address, lat, lng) {
        document.getElementById('location').value = address;
        document.getElementById('lat').value = lat;
        document.getElementById('lng').value = lng;
    }

    google.maps.event.addDomListener(window, 'load', initialize);
</script>
</body>
</html>