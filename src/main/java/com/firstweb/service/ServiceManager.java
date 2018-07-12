package com.firstweb.service;

import com.firstweb.model.Location;

import java.util.List;

/**
 * Purpose: service layer interface to provide access to method of ServiceManagerImpl class
 * {@link ServiceManagerImpl}
 */
public interface ServiceManager {

    /**
     *Purpose: add new location with dao method {@link com.FirstWeb.repository.LocationDaoImpl}
     *
     * @param location
     * @return response status as zero or non zero according to success or failure
     */
    int add(Location location);

    /**
     * Purpose: retrieve locations with dao method
     *
     * @return list of all location store in database
     */
    List display();

    /**
     * Purpose: delete specific location with dao method
     *
     * @param location
     * @return response status as zero or non zero according to success or failure
     */
    int delete(Location location);

    /**
     * Purpose: get specific location data with dao method
     *
     * @param location
     * @return list location data like address,longitude,latitude
     */
    List getLocation(Location location);

    /**
     * Purpose: update specific location with dao method
     *
     * @param location
     * @return response status as zero or non zero according to success or failure
     */
    int updateLocation(Location location);
}
