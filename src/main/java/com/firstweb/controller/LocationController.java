package com.firstweb.controller;

import com.firstweb.model.Location;
import com.firstweb.service.ServiceManager;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

/**
 * controller class of FirstWeb project
 */
@Controller
public class LocationController {

    /**
     * Logger implementation for logging
     */
    private static final Logger LOGGER = LogManager.getLogger(LocationController.class);

    @Autowired
    private ServiceManager serviceManager;

    /**
     * Purpose: display Index page
     *
     * @return view of welcome Index Page
     */
    @RequestMapping(value = "/Index", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView welcome() {
        ModelAndView modelAndView = new ModelAndView("Index");
        return modelAndView;
    }

    /**
     * Purpose : add location to database
     *
     * @param location
     * @param result
     * @return response text according to operation success or failure to jsp page
     */
    @RequestMapping(value = "/AddLocation", method = RequestMethod.GET)
    public @ResponseBody
    String addLocation(@ModelAttribute(value = "getLocation") Location location, BindingResult result) {

        String returnText;
        int status = 0;

        if (!result.hasErrors()) {
            LOGGER.info("Method is calling service layer method");
            status = serviceManager.add(location);
        }

        if (status != 0) {
            returnText = "Location " + location.getAddress() + " has been added to the list";
            LOGGER.info("The Location {} is successfully saved",location.getAddress());
        } else {
            returnText = "Sorry, an error has occur. Location has not been added to list.";
            LOGGER.info("Error occurs.The Location {} is not Save in database",location.getAddress());
        }
        return returnText;
    }

    /**
     * Purpose: display all retrieved location from database
     *
     * @return view of all location in table format
     */
    @RequestMapping(value = "/Display", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView displayAllLocations() {

        ModelAndView modelAndView = new ModelAndView("DisplayLocations");
        LOGGER.info("Method is calling service layer method");
        List list = serviceManager.display();
        LOGGER.info("Got {} locations from database",list.size());
        modelAndView.addObject("getList", list);
        return modelAndView;
    }

    /**
     * Purpose: delete specific location from database
     *
     * @param location
     * @param result
     * @return response text according to operation success or failure to jsp page
     */
    @RequestMapping(value = "/Delete", method = RequestMethod.GET)
    public @ResponseBody
    String delete(@ModelAttribute(value = "getLocation") Location location, BindingResult result) {
        String returnText;
        int status = 0;
        if (!result.hasErrors()) {
            LOGGER.info("Method is calling service layer method");
            status = serviceManager.delete(location);
        }
        if (status != 0) {
            returnText = "ADDRESS- (" + location.getAddress() + ") IS DELETED";
            LOGGER.info("The Location {} is successfully deleted",location.getAddress());
        } else {
            returnText = "Sorry, an error has occur. Address- (" + location.getAddress() + ") isn't deleted from database";
            LOGGER.info("Error occurs.The Location {} is not delete in database",location.getAddress());
        }
        return returnText;
    }

    /**
     * Purpose: show particular location on static map with non draggable marker
     *
     * @param location
     * @param result
     * @return view of static map for given location
     */
    @RequestMapping(value = "/Edit", method = RequestMethod.GET)
    @ResponseBody
    public ModelAndView showLocation(@ModelAttribute(value = "getLocation") Location location, BindingResult result) {
        ModelAndView modelAndView = new ModelAndView("/EditLocation");
        LOGGER.info("Method is calling service layer method");
        List list = serviceManager.getLocation(location);
        LOGGER.info("Location retrieved from database");
        modelAndView.addObject("getList", list);
        return modelAndView;
    }

    /**
     * Purpose: update location with updated data of location
     *
     * @param location
     * @param result
     * @return response text according to operation success or failure to jsp page
     */
    @RequestMapping(value = "/Update", method = RequestMethod.GET)
    @ResponseBody
    public String update(@ModelAttribute("getLocation") Location location, BindingResult result) {
        String returnText;
        int status = 0;

        if (!result.hasErrors()) {
            LOGGER.info("Method is calling service layer method");
            status = serviceManager.updateLocation(location);
        }

        if (status != 0) {
            if(location.getLocationID().equals(location.getAddress())){
                returnText = "No update in existing location data";
                LOGGER.info("location already exist in database");
            }else{
                returnText = "Address-" + location.getAddress() + " is updated in database";
                LOGGER.info("The Location {} is successfully updated",location.getAddress());
            }
        } else {
            returnText = "Sorry, an error has occur.Address-" + location.getAddress() + " isn't updated in database";
            LOGGER.info("Error occurs.The Location {} is not updated in database",location.getAddress());
        }
        return returnText;
    }
}
