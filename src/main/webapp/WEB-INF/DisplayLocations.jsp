<%--@elvariable id="getLocation" type=""--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: lakshay
  Date: 5/3/18
  Time: 8:32 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

    <style>
        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
            background-color: khaki;
        }

    </style>
</head>

<body>
<table class="LocationTable">
    <thead>
    <tr>
        <th>Address</th>
        <th>Longitude</th>
        <th>Latitude</th>
        <th>
            <button id="Home" onclick="goToHome();">Home</button>
        </th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="LocationList" items="${getList}">
        <tr class="<c:out value="${LocationList.getAddress()}"/>">
            <td>
                <c:out value="${LocationList.getAddress()}"/>
            </td>
            <td>
                <c:out value="${LocationList.getLongitude()}"/>
            </td>
            <td>
                <c:out value="${LocationList.getLatitude()}"/>
            </td>
            <td>
                <button id="Delete" name="Delete"
                        onclick="doDeleteAjax('<c:out value="${LocationList.getAddress()}"/>');">Delete
                </button>
            </td>
            <td>
                <button id="Edit" name="Edit"
                        onclick="doEditAjax('<c:out value="${LocationList.getAddress()}"/>');">Edit
                </button>
            </td>
        </tr>
    </c:forEach>
    </tbody>

</table>

<script>

    function goToHome() {
      $.ajax({
          type: "GET",
          url: "<c:url value="/Index"/>",
          success: function () {
              window.location.href = "<c:url value="/Index"/>"
          }
      });
    }

    function doEditAjax(address) {
        var data = {
            address: address
        };
        $.ajax({
            type: "GET",
            url: "<c:url value="/Edit"/>",
            data: data,
            success: function (response) {
                $(".LocationTable").html(response);
            },
            error: function (e) {
                alert('Error:' + e)
            }
        });

    }

    function doDeleteAjax(address) {
        var location = document.getElementsByClassName(address);
        var data = {
            address: address
        };
        $.ajax({
            type: "GET",
            url: "<c:url value="/Delete"/>",
            data: data,
            success: function (response) {
                alert(response);
                $(location).hide();
            },
            error: function (e) {
                alert('Error: ' + e);
            }
        });
    }
</script>

</body>
</html>