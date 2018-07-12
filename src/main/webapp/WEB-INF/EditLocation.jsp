<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: virat
  Date: 7/3/18
  Time: 3:35 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

    <script src="https://maps.googleapis.com/maps/api/js?sensor=false&libraries=places"></script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <script async defer
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBjov4cDMVMbkqKKBW8-jviVZefD8_4CvY&callback=initMap">
    </script>

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

        input[type=button], select {
            width: 20%;
            padding: 5px 5px;
            margin: 8px 0;
        }

        .Invisible{
            display: none!important;
        }
        .right{
            float: right;
        }
    </style>
</head>
<body>

<div class="edit_area">
    <div id="editMap" style="width: 100%; height: 400px;"></div>

    <c:forEach var="location" items="${getList}">

        <input type="text" class="Invisible" id="currentLocation" value="<c:out value="${location.getLocationID()}"/>">

        <input type="text" id="location" value="<c:out value="${location.getAddress()}"/>" readonly>

        <input type="text" id="lng" value="<c:out value="${location.getLongitude()}"/>" readonly>

        <input type="text" id="lat" value="<c:out value="${location.getLatitude()}"/>" readonly><br>

    </c:forEach>

    <button id="Save" onclick="doSaveAjax();">Save</button>


    <button id="Display" name="Display" onclick="doShowAjax();">Display</button>

    <button class="right" name="edit" onclick="initialize();">Edit</button>

</div>

<script>
    function initMap() {
        var latitude = $('#lat').val();

        var longitude = $('#lng').val();

        var latlng = new google.maps.LatLng(latitude, longitude);


        var map = new google.maps.Map(document.getElementById('editMap'), {
            zoom: 13,
            center: latlng,
        });

        var marker = new google.maps.Marker({
            position: latlng,
            map: map
        });

    }

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

    function doSaveAjax() {

        var locationID = $('#currentLocation').val();
        var location = $('#location').val();
        var lat = $('#lat').val();
        var lng = $("#lng").val();

        var data = {
            locationID: locationID,
            address: location,
            longitude: lng,
            latitude: lat
        };

        $.ajax({
            type: "GET",
            url: "<c:url value="/Update"/>",
            data: data,
            success: function (response) {
                alert(response);
            },
            error: function (e) {
                alert('Error: ' + e);
            }
        });
    }
</script>

<script>
    function initialize() {

        var lat = $('#lat').val();
        var lng = $("#lng").val();

        var latlng = new google.maps.LatLng(lat, lng);
        var map = new google.maps.Map(document.getElementById('editMap'), {
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
