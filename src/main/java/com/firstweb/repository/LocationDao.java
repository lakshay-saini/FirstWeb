package com.firstweb.repository;

import com.firstweb.model.Location;

import java.util.List;

/**
 * {@link LocationDaoImpl}
 */
public interface LocationDao {

    /**
     * Purpose: add new location in database
     *
     * @param location
     * @return response status as zero or non zero according to success or failure
     */
    int add(Location location);

    /**
     * Purpose: retrieve locations from database
     *
     * @return list of all location store in database
     */
    List display();

    /**
     * Purpose: delete specific location from database
     *
     * @param location
     * @return response status as zero or non zero according to success or failure
     */
    int delete(Location location);

    /**
     * Purpose: get specific location data from database
     *
     * @param location
     * @return list location data like address,longitude,latitude
     */
    List getLocation(Location location);

    /**
     * Purpose: update specific location data in database
     *
     * @param location
     * @return response status as zero or non zero according to success or failure
     */
    int updateLocation(Location location);
}
