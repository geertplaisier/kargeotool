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

import javax.persistence.*;

/**
 * Entity voor KAR soort voertuig uit BISON koppelvlak 9. Zie bestand 
 * "database/05 insert vehicle types.sql".
 * 
 * @author Matthijs Laan
 */
@Entity
public class VehicleType {
    
    /**
     * Waarde voor in Kv9 XML; KARb1 bericht attribuut 2.
     */
    @Id
    private int nummer;
    
    /**
     * Omschrijving van het soort voertuig.
     */
    private String omschrijving;
    
    private String groep;

    public static final String VEHICLE_TYPE_OV = "OV";
    public static final String VEHICLE_TYPE_HULPDIENSTEN = "Hulpdiensten";
    public static final String VEHICLE_TYPE_GEMIXT = "Gemixt";

    /**
     *
     * @return nummer
     */
    public int getNummer() {
        return nummer;
    }

    /**
     *
     * @param nummer nummer
     */
    public void setNummer(int nummer) {
        this.nummer = nummer;
    }

    /**
     *
     * @return omschrijving
     */
    public String getOmschrijving() {
        return omschrijving;
    }

    /**
     *
     * @param omschrijving omschrijving
     */
    public void setOmschrijving(String omschrijving) {
        this.omschrijving = omschrijving;
    }

    public String getGroep() {
        return groep;
    }

    public void setGroep(String groep) {
        this.groep = groep;
    }
    
    
    
}
