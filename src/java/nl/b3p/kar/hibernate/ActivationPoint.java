/**
 * Geo-OV - applicatie voor het registreren van KAR meldpunten               
 *                                                                           
 * Copyright (C) 2009-2013 B3Partners B.V.                                   
 *                                                                           
 * This program is free software: you can redistribute it and/or modify      
 * it under the terms of the GNU Affero General Public License as            
 * published by the Free Software Foundation, either version 3 of the        
 * License, or (at your option) any later version.                           
 *                                                                           
 * This program is distributed in the hope that it will be useful,           
 * but WITHOUT ANY WARRANTY; without even the implied warranty of            
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the              
 * GNU Affero General Public License for more details.                       
 *                                                                           
 * You should have received a copy of the GNU Affero General Public License  
 * along with this program. If not, see <http://www.gnu.org/licenses/>.      
 */

package nl.b3p.kar.hibernate;

import com.vividsolutions.jts.geom.Point;
import javax.persistence.*;

/**
 * Entity voor persisteren van een Activation Point zoals bedoeld in BISON 
 * koppelvlak 9.
 *
 * @author Matthijs Laan
 */
@Entity
public class ActivationPoint {
    
    /**
     * Automatisch gegenereerde unieke sleutel volgens een sequence. Niet zichtbaar
     * in Kv9 XML export.
     */
    @Id 
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;

    /**
     * Roadside equipment waarbij deze movement hoort.
     */
    @ManyToOne(optional=false)
    private RoadsideEquipment roadsideEquipment;
    
    /**
     * Nummer van het activation point binnen een enkele VRI.
     */
    @Basic(optional=false)
    private Integer nummer;
    
    /**
     * Geografische locatie van het activation point.
     */
    @Basic(optional=false)
    @org.hibernate.annotations.Type(type="org.hibernatespatial.GeometryUserType")
    private Point location;
    
    /**
     * Tekstuele aanduiding van het activation point, te tonen als label op de kaart.
     */
    private String label;

    //<editor-fold defaultstate="collapsed" desc="getters en setters">
    /**
     *
     * @return id
     */
    public Long getId() {
        return id;
    }
    
    /**
     *
     * @param id
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     *
     * @return roadsideEquipment
     */
    public RoadsideEquipment getRoadsideEquipment() {
        return roadsideEquipment;
    }

    /**
     *
     * @param roadsideEquipment
     */
    public void setRoadsideEquipment(RoadsideEquipment roadsideEquipment) {
        this.roadsideEquipment = roadsideEquipment;
    }

    /**
     *
     * @return nummer
     */
    public Integer getNummer() {
        return nummer;
    }

    /**
     *
     * @param nummer
     */
    public void setNummer(Integer nummer) {
        this.nummer = nummer;
    }
    
    /**
     *
     * @return location
     */
    public Point getLocation() {
        return location;
    }
    
    /**
     *
     * @param location
     */
    public void setLocation(Point location) {
        this.location = location;
    }
    
    /**
     *
     * @return label
     */
    public String getLabel() {
        return label;
    }
    
    /**
     *
     * @param label
     */
    public void setLabel(String label) {
        this.label = label;
    }
    //</editor-fold>
 
}
