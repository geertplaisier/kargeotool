<%--
 Geo-OV - applicatie voor het registreren van KAR meldpunten               
                                                                           
 Copyright (C) 2009-2013 B3Partners B.V.                                   
                                                                           
 This program is free software: you can redistribute it and/or modify      
 it under the terms of the GNU Affero General Public License as            
 published by the Free Software Foundation, either version 3 of the        
 License, or (at your option) any later version.                           
                                                                           
 This program is distributed in the hope that it will be useful,           
 but WITHOUT ANY WARRANTY; without even the implied warranty of            
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the              
 GNU Affero General Public License for more details.                       
                                                                           
 You should have received a copy of the GNU Affero General Public License  
 along with this program. If not, see <http://www.gnu.org/licenses/>.      
--%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page errorPage="/WEB-INF/jsp/commons/errorpage.jsp" %>

<stripes:layout-render name="/WEB-INF/jsp/commons/siteTemplate.jsp">

    <stripes:layout-component name="headerlinks" >
        <%@include file="/WEB-INF/jsp/commons/headerlinks.jsp" %>

    </stripes:layout-component>
    <stripes:layout-component name="content">


        <script type="text/javascript">

            var exportActionBeanUrl = "<stripes:url beanclass="nl.b3p.kar.stripes.ExportActionBean" />";
            var profile = {
            };

            <c:if test="${!empty actionBean.gebruiker.profile}">
            profile = ${actionBean.gebruiker.profile};
            </c:if>

            var deelgebieden = [];
            <c:forEach items="${actionBean.deelgebieden}" var="dg">
                var deelgebied = {
                    name : "${dg.name}",
                    id: "${dg.id}"
                };
                deelgebieden.push(deelgebied);
            </c:forEach>
            var dataowners = [];
            <c:forEach items="${actionBean.dataowners}" var="dataowner">
                var dataowner = {
                    id: "${dataowner.id}",
                    omschrijving : "${dataowner.omschrijving}",
                    code: "${dataowner.code}"
                };
                dataowners.push(dataowner);
            </c:forEach>
        </script>

        <script type="text/javascript" src="${contextPath}/js/profilestate.js"></script>
        <script type="text/javascript" src="${contextPath}/js/settings.js"></script>
        <script type="text/javascript" src="${contextPath}/js/export.js"></script>
        <h1>Exporteer verkeerssystemen</h1>

                <stripes:messages/>
                <stripes:errors/>
        <div id="body" class="exportBody">
        </div>


</stripes:layout-component>
</stripes:layout-render>