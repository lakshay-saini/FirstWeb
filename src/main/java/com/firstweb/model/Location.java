package com.firstweb.model;

import org.springframework.stereotype.Component;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * Java Bean with hibernate Entity annotation for fetching with existing database table
 * or to create a new table
 */
@Component
@Entity
public class Location implements Serializable{

    @Id
    private String locationID;

    @NotNull
    private String address;

    @NotNull
    private Double latitude;

    @NotNull
    private Double longitude;

    public String getAddress() {
        return address;
    }


    public void setAddress(String address) {
        this.address = address;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getLocationID() {
        return locationID;
    }

    public void setLocationID(String locationID) {
        this.locationID = locationID;
    }
}
