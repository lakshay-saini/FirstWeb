package com.firstweb.repository;

import com.firstweb.model.Location;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class LocationDaoImpl implements LocationDao {

    private static final Logger LOGGER = LogManager.getLogger(LocationDaoImpl.class);

    public int add(Location location) {
        int status = 0;

        location.setLocationID(IDGenerator(location));

        LOGGER.info("Generated LocationID for Location");

        SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
        Session session = sessionFactory.openSession();

        try {
            session.beginTransaction();
            session.save(location);
            session.getTransaction().commit();
            LOGGER.info("Location {} is going to save in Database", location.getAddress());
            status++;
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
        } finally {
            session.close();
            sessionFactory.close();
        }
        return status;
    }


    public List display() {
        List data;
        SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
        Session session = sessionFactory.openSession();
        try {
            session.beginTransaction();
            data = session.createQuery("from Location ").list();
            session.getTransaction().commit();
            LOGGER.info("Getting {} Locations from database", data.size());

        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
            return null;
        } finally {
            session.close();
            sessionFactory.close();
        }
        return data;
    }


    public int delete(Location location) {
        int status = 0;
        SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
        Session session = sessionFactory.openSession();
        try {
            session.beginTransaction();
            Query query = session.createQuery("delete from Location where address= :address");
            query.setParameter("address", location.getAddress());
            status = query.executeUpdate();
            session.getTransaction().commit();
            LOGGER.info("Location {} is going to delete from database", location.getAddress());
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
        } finally {
            sessionFactory.close();
            session.close();
        }
        return status;
    }

    public List getLocation(Location location) {
        List data;
        SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
        Session session = sessionFactory.openSession();
        try {
            session.beginTransaction();
            Query query = session.createQuery("from Location where address = :address");
            query.setParameter("address", location.getAddress());
            data = query.list();
            session.getTransaction().commit();
            LOGGER.info("Getting Location {} from database", location.getAddress());
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
            return null;
        } finally {
            session.close();
            sessionFactory.close();
        }
        return data;
    }

    public int updateLocation(Location location) {
        int status = 0;
        SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
        Session session = sessionFactory.openSession();
        try {
            session.beginTransaction();
            Query query = session.createQuery("update Location location set location.address = :address, location.latitude = :latitude,location.longitude =:longitude where location.locationID = :locationID");
            query.setParameter("address", location.getAddress());
            query.setParameter("latitude", location.getLatitude());
            query.setParameter("longitude", location.getLongitude());
            query.setParameter("locationID", location.getLocationID());
            status = query.executeUpdate();
            session.getTransaction().commit();
            LOGGER.info("Location with LocationId: {}  is going to update in database",location.getLocationID());
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
        } finally {
            session.close();
            sessionFactory.close();
        }
        return status;
    }

    /**
     * Purpose: generate locationID for location
     *
     * @param location
     * @return location address as locationID
     */
    private String IDGenerator(Location location) {
        return location.getAddress();
    }
}
