<%--
 KAR Geo Tool - applicatie voor het registreren van KAR meldpunten               
                                                                           
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

        <script type="text/javascript" src="${contextPath}/js/rights.js"></script>
        <script type="text/javascript">
            var rseqs = ${actionBean.rseqs};
            var rightsUrl = "<stripes:url beanclass="nl.b3p.kar.stripes.RightsActionBean" event="edit"/>";
            Ext.onReady(function(){
                loadGrid();
            });
        </script>
        <h1>Rechten op verkeerssystemen</h1>
        <div id="body" class="exportBody">
           
        </div>
        
        <iframe style="width:100%; height:500px;border:0px;" id="VRIDetail" src=""/>

    </stripes:layout-component>
</stripes:layout-render>