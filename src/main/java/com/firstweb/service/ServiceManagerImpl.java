package com.firstweb.service;

import com.firstweb.model.Location;
import com.firstweb.repository.LocationDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Purpose: service layer implementation class to implement the ServiceManger class method
 */
@Service
public class ServiceManagerImpl implements ServiceManager {

    @Autowired
    private LocationDao locationDao;

    public int add(Location location) {
        return locationDao.add(location);
    }

    public List display() {
        return locationDao.display();
    }

    public int delete(Location location) {
        return locationDao.delete(location);
    }

    public List getLocation(Location location) {
        return locationDao.getLocation(location);
    }

    public int updateLocation(Location location) {
        return locationDao.updateLocation(location);
    }
}
