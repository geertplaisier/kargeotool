/**
 * Geo-OV - applicatie voor het registreren van KAR meldpunten
 *
 * Copyright (C) 2018 B3Partners B.V.
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
package nl.b3p.kar.stripes;

import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.geom.Point;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import javax.persistence.EntityManager;
import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.FileBean;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StrictBinding;
import net.sourceforge.stripes.action.UrlBinding;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.geotools.data.dxf.DXFDataStore;
import nl.b3p.kar.hibernate.DataOwner;
import nl.b3p.kar.hibernate.Gebruiker;
import nl.b3p.kar.hibernate.RoadsideEquipment;
import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.geotools.data.DataStore;
import org.geotools.data.DataStoreFinder;
import org.geotools.data.DataUtilities;
import org.geotools.data.DefaultTransaction;
import org.geotools.data.Transaction;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureIterator;
import org.geotools.data.simple.SimpleFeatureSource;
import org.geotools.data.simple.SimpleFeatureStore;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.feature.type.AttributeDescriptor;
import org.stripesstuff.stripersist.Stripersist;

/**
 *
 * @author Meine Toonen
 */
@StrictBinding
@UrlBinding("/action/upload")
public class UploadDXFActionBean implements ActionBean {

    private static final Log log = LogFactory.getLog(UploadDXFActionBean.class);
    private ActionBeanContext context;

    private SimpleFeatureBuilder featureBuilder;

    private final String JSP_VIEW = "/WEB-INF/jsp/dxf/view.jsp";
    
    @Validate(required = true, on = "upload")
    private FileBean bestand;
    
    @Validate(required = true)
    private RoadsideEquipment rseq;
    
    @Validate
    private String description;
    
    @Validate
    private DataOwner dataowner;
    
    private Gebruiker gebruiker = null;
    
    private List<DataOwner> dataowners;
    
    // <editor-fold desc="Getters and setters" defaultstate="collapsed">
    public void setDataowners(List<DataOwner> dataowners) {
        this.dataowners = dataowners;
    }

    public List<DataOwner> getDataowners() {
        return dataowners;
    }

    public DataOwner getDataowner() {
        return dataowner;
    }

    public void setDataowner(DataOwner dataowner) {
        this.dataowner = dataowner;
    }
    
    public FileBean getBestand() {
        return bestand;
    }

    public void setBestand(FileBean bestand) {
        this.bestand = bestand;
    }

    @Override
    public ActionBeanContext getContext() {
        return context;
    }

    @Override
    public void setContext(ActionBeanContext context) {
        this.context = context;
    }

    public SimpleFeatureBuilder getFeatureBuilder() {
        return featureBuilder;
    }

    public void setFeatureBuilder(SimpleFeatureBuilder featureBuilder) {
        this.featureBuilder = featureBuilder;
    }

    public RoadsideEquipment getRseq() {
        return rseq;
    }

    public void setRseq(RoadsideEquipment rseq) {
        this.rseq = rseq;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
    // </editor-fold>

    @DefaultHandler
    public Resolution view() {
        EntityManager em = Stripersist.getEntityManager();
        
        dataowners = em.createQuery("from DataOwner order by classificatie, omschrijving").getResultList();
        return new ForwardResolution(JSP_VIEW);
    }

    public Resolution upload() {
        try {
            gebruiker = (Gebruiker) context.getRequest().getUserPrincipal();
            File f = File.createTempFile("dxfupload", "" + System.currentTimeMillis());
            FileUtils.copyInputStreamToFile(bestand.getInputStream(), f);
            processFile(f, createDbDatastore());
        } catch (IOException ex) {
            log.error("Error reading dxf", ex);
        }
        return view();
    }

    private void processFile(File file, DataStore dataStore2Write) {
        try {
            URL dxf_url = file.toURL();
            DXFDataStore dataStore2Read = new DXFDataStore(dxf_url, "EPSG:28992");

            String[] typeNames = dataStore2Read.getTypeNames();
            for (String typeName : typeNames) {
                saveFeatures(dataStore2Read, dataStore2Write, "dxf", typeName);
            }
        } catch (Exception ex) {
            log.info(ex.getLocalizedMessage());
        }
    }

    private void saveFeatures(DataStore source, DataStore dest, String destFeatureType, String sourceFeatureType) throws IOException, Exception {
        // Generate the shapefile
        SimpleFeatureSource sfs = source.getFeatureSource(sourceFeatureType);
        SimpleFeatureType sft = (SimpleFeatureType) sfs.getSchema();
        SimpleFeatureCollection sourceFc = sfs.getFeatures();

        SimpleFeatureStore destFs = (SimpleFeatureStore) dest.getFeatureSource(destFeatureType);
        SimpleFeatureType t = destFs.getSchema();

        featureBuilder = new SimpleFeatureBuilder(t);

        //maak een transactie
        Transaction transaction = new DefaultTransaction("create");
        destFs.setTransaction(transaction);

        //schrijf de data
        try {

            List<SimpleFeature> features = new ArrayList<>();
            SimpleFeatureIterator it = sourceFc.features();
            while (it.hasNext()) {
                SimpleFeature sourceFeature = it.next();
                SimpleFeature destFeature = processFeature(sourceFeature, sft);
                features.add(destFeature);
            }
            SimpleFeatureCollection collection = DataUtilities.collection(features);
            destFs.addFeatures(collection);
            transaction.commit();
        } catch (IOException | NoSuchElementException exc) {
            log.error("Fout bij schrijven van features naar datastore... Doe rollback", exc);
            transaction.rollback();
            throw exc;
        } finally {
            transaction.close();
            dest.dispose();
        }
    }

    private SimpleFeature processFeature(SimpleFeature source, SimpleFeatureType newFt) {
        Object geom = source.getDefaultGeometry();
        if(geom == null){
            return null;
        }
        Geometry g = (Geometry)geom;
        Point p = g.getCentroid();
        if (p.getX() < 646 || p.getY() < 308975) {
            return null;
        }
        for (AttributeDescriptor attributeDescriptor : newFt.getAttributeDescriptors()) {
            Object b = source.getAttribute(attributeDescriptor.getLocalName());
            featureBuilder.set(attributeDescriptor.getName(), b);
        }
        
        featureBuilder.set("data_owner", dataowner.getId());
        featureBuilder.set("user_", gebruiker.getId());
        featureBuilder.set("filename", bestand.getFileName());
        featureBuilder.set("uploaddate", new Date());
        featureBuilder.set("rseq", rseq.getId());
        featureBuilder.set("description", description);
        SimpleFeature feature = featureBuilder.buildFeature(null);
        return feature;
    }

    private static DataStore createDbDatastore() throws IOException {
        EntityManager em = Stripersist.getEntityManager();
        Map<String, Object> props = em.getEntityManagerFactory().getProperties();
        String url = (String) props.get("hibernate.connection.url");
        String host = url.substring(url.indexOf("://") + 3, url.lastIndexOf(":"));
        String port = url.substring(url.lastIndexOf(":") + 1, url.lastIndexOf("/"));
        String database = url.substring(url.lastIndexOf("/") + 1);
        String schema = (String) props.get("hibernate.default_schema");
        String user = (String) props.get("hibernate.connection.username");
        String password = (String) props.get("hibernate.connection.password");

        Map<String, Object> params = new HashMap<>();
        params.put("dbtype", "postgis");
        params.put("host", host);
        params.put("port", port);
        params.put("schema", schema);
        params.put("database", database);
        params.put("user", user);
        params.put("passwd", password);

        DataStore dataStore = DataStoreFinder.getDataStore(params);
        return dataStore;
    }

    
}
