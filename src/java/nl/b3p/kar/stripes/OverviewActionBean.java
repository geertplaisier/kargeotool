/**
 * Geo-OV - applicatie voor het registreren van KAR meldpunten
 *
 * Copyright (C) 2009-2014 B3Partners B.V.
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
package nl.b3p.kar.stripes;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StrictBinding;
import net.sourceforge.stripes.action.UrlBinding;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.kar.hibernate.Gebruiker;
import nl.b3p.kar.hibernate.InformMessage;
import nl.b3p.kar.hibernate.RoadsideEquipment;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.stripesstuff.stripersist.Stripersist;

/**
 *
 * @author Meine Toonen
 */
@StrictBinding
@UrlBinding("/action/overview")
public class OverviewActionBean implements ActionBean{
    private static final Log log = LogFactory.getLog(DetermineAllVRITypeActionBean.class);


    private static final String OVERVIEW_CARRIER = "/WEB-INF/jsp/overview/carrier.jsp";
    private static final String OVERVIEW_DATAOWNER = "/WEB-INF/jsp/overview/dataowner.jsp";

    private ActionBeanContext context;

    private List<InformMessage> messages = new ArrayList<InformMessage>();

    @Validate
    private InformMessage message;

    @DefaultHandler
    public Resolution overview(){
        return new ForwardResolution(OVERVIEW_DATAOWNER);
    }

    public Resolution readMessage(){

        EntityManager em = Stripersist.getEntityManager();
        message.setMailProcessed(true);
        em.persist(message);
        em.getTransaction().commit();
        return carrier();
    }

    public Resolution carrier(){
        EntityManager em = Stripersist.getEntityManager();

        messages = em.createQuery("From InformMessage where vervoerder = :vervoerder and mailSent = true and mailProcessed = false", InformMessage.class).setParameter("vervoerder", getGebruiker()).getResultList();
        return new ForwardResolution(OVERVIEW_CARRIER);
    }

    // <editor-fold desc="Getters and setters" defaultstate="collapsed">
    public ActionBeanContext getContext() {
        return context;
    }

    public void setContext(ActionBeanContext context) {
        this.context = context;
    }

    public List<InformMessage> getMessages() {
        return messages;
    }

    public void setMessages(List<InformMessage> messages) {
        this.messages = messages;
    }

    public InformMessage getMessage() {
        return message;
    }

    public void setMessage(InformMessage message) {
        this.message = message;
    }

    public Gebruiker getGebruiker() {
        final String attribute = this.getClass().getName() + "_GEBRUIKER";
        Gebruiker g = (Gebruiker) getContext().getRequest().getAttribute(attribute);
        if (g != null) {
            return g;
        }
        Gebruiker principal = (Gebruiker) context.getRequest().getUserPrincipal();
        g = Stripersist.getEntityManager().find(Gebruiker.class, principal.getId());
        getContext().getRequest().setAttribute(attribute, g);
        return g;
    }
    // </editor-fold>

}
