<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<!DOCTYPE html> 
<%@page errorPage="/WEB-INF/jsp/commons/errorpage.jsp" %>
<stripes:layout-render name="/WEB-INF/jsp/commons/siteTemplate2.jsp">

    <stripes:layout-component name="headerlinks" >
        <%@include file="/WEB-INF/jsp/commons/headerlinks2.jsp" %>

    </stripes:layout-component>
    <stripes:layout-component name="content">

        <script type="text/javascript" src="${contextPath}/js/proj4js-compressed.js"></script>
        <script type="text/javascript">
            Proj4js.defs["EPSG:28992"] = "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.237,50.0087,465.658,-0.406857,0.350733,-1.87035,4.0812 +units=m +no_defs";
            Proj4js.defs["EPSG:4236"] = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ";                    
        </script>
        <script type="text/javascript" src="${contextPath}/js/layout.js"></script>
        <script type="text/javascript">

          
            var editorActionBeanUrl = "<stripes:url beanclass="nl.b3p.kar.stripes.EditorActionBean" />";
            var contextPath = "${contextPath}";
   
/*
            setOnload(function() 
            {
                document.getElementById("walapparaatnummer").focus();
                if("${magWalapparaatMaken}" == "true"){
                    document.getElementById("newRseq").disabled = false;
                }else{
                    document.getElementById("newRseq").disabled = true;
                }
            });
            */
        </script>

        <div id="leftbar">
            
            <div id="searchform">
                Adres verkeerssysteem: <input id="addressInput" name="address" value="9999" size="6"> <input type="button" value="Zoeken" onclick="editor.loadRseqInfo({karAddress:Ext.get('addressInput').getValue()}, function() { editor.zoomToActiveRseq(); } );"><br />
                Adres zoeken: <input id="geocodeAddressInput" name="geocode_address" value="" size="17"> <input type="button" value="Zoeken" onclick="editor.geocode(Ext.get('geocodeAddressInput').getValue());">
                <div id="geocoderesults"></div>
            </div>
            
            <div id="rseqInfoPanel">
                <div style="margin: 3px">
                    Huidig geselecteerde VRI: <span id="context_vri"></span>
                    <p><br>
                    <input type="button" id="rseqSave" value="Opslaan" style="visibility: hidden" onclick="editor.saveOrUpdate()">
                </div>
            </div>
            
            <div id="form">
                <div id="help">
                    Klik op een icoon van een verkeerssysteem om de details te
                    bekijken of klik rechts om een verkeerssysteem toe te voegen.
                </div>
            </div>

        </div>

        <div id="kaart">
            <div id="map" style="width: 100%; height: 100%;"></div>
            <!--div id="overview" style="width:19%;border:1px solid #000; float:right; height:300px;overflow:hidden;"></div-->
        </div>
        
        <div id="rightbar">
            <div id="legend">
                <div id="walapparatuur" class="legendseparator">
                    <input type="checkbox" checked="checked" onclick="toggleLayer('walapparatuur');"/> Verkeerssystemen<br/>
                    <img src="<c:url value="/images/"/>icons/vri.png" alt="VRI" class="legendimg" /> VRI<br />
                    <img src="<c:url value="/images/"/>icons/wri.png" alt="Waarschuwingssysteem" class="legendimg" /> Waarschuwingssysteem<br />
                    <img src="<c:url value="/images/"/>icons/afsluitingssysteem.png" alt="Afsluitingssysteem" class="legendimg" /> Afsluitingssysteem<br />
                </div>
                <div id="triggerpunten" class="legendseparator">
                    <input type="checkbox" checked="checked" onclick="toggleLayer('triggerpunten');"/> Punten<br/>
                    <img src="<c:url value="/images/"/>/icons/radio_zwart.png" alt="Onbekend" class="legendimg" /> Onbekend<br />
                    <img src="<c:url value="/images/"/>/icons/radio_groen.png" alt="Inmeldpunt" class="legendimg" /> Inmeldpunt<br />
                    <img src="<c:url value="/images/"/>/icons/radio_rood.png" alt="Uitmeldpunt" class="legendimg" /> Uitmeldpunt<br />
                    <img src="<c:url value="/images/"/>/icons/radio_blauw.png" alt="Vooraanmeldpunt" class="legendimg" /> Vooraanmeldpunt<br />
                </div>
                <div id="starteindpunten" class="legendseparator">
                    <input type="checkbox" checked="checked" /> Begin- en eindpunten<br/>
                    <img src="<c:url value="/images/"/>/icons/beginpunt.png" alt="Beginpunt" class="legendimg" /> Beginpunt<br />
                    <img src="<c:url value="/images/"/>/icons/eindpunt.png" alt="Eindpunt" class="legendimg" /> Eindpunt<br />
                </div><br/>
                <strong>OV-informatie</strong><br/>
                <input type="checkbox" onclick="toggleLayer('buslijnen');"/>Buslijnen<br/>
                <div style="display:none;" id="buslijnen"><img src="http://x13.b3p.nl/cgi-bin/mapserv?map=/home/matthijsln/geo-ov/transmodel_connexxion_edit.map&amp;version=1.1.1&amp;service=WMS&amp;request=GetLegendGraphic&amp;layer=buslijnen&amp;format=image/png"/></div>
                <input type="checkbox" onclick="toggleLayer('bushaltes');"/>Bushaltes<br/>
                <div style="display:none;" id="bushaltes"><img src="http://x13.b3p.nl/cgi-bin/mapserv?map=/home/matthijsln/geo-ov/transmodel_connexxion_edit.map&amp;version=1.1.1&amp;service=WMS&amp;request=GetLegendGraphic&amp;layer=bushaltes_symbol&amp;format=image/png"/></div><br/>
                <strong>Achtergrond</strong><br/>
                <input type="checkbox" onclick="toggleLayer('Luchtfoto');"/>Luchtfoto<br/>
                <input type="checkbox" checked="checked" onclick="toggleLayer('BRT');"/>BRT<br/>
            </div>
            <script type="text/javascript" src="<c:url value="/js/editor.js"/>"></script>
            <script type="text/javascript">
                
                var mapfilePath = "http://x13.b3p.nl/cgi-bin/mapserv?map=/home/matthijsln/geo-ov/transmodel_connexxion_edit.map";
                
                var editor = null;
                Ext.onReady(function() {
                    editor = Ext.create(Editor, "map", mapfilePath);    
                });
                
                var vehicleTypes = ${actionBean.vehicleTypesJSON};
                var dataOwners = ${actionBean.dataOwnersJSON};
                
                function toggleLayer(layer) {
                    var legend = document.getElementById(layer);
                    var visible = editor.olc.isLayerVisible(layer);

                    editor.olc.setLayerVisible(layer,!visible);
                    if(legend){
                        var attr = !visible ?  'block' : 'none' ;
                        legend.setAttribute("style", 'display:' +attr);
                    }
                }
                    
            </script>
        </div>

    </stripes:layout-component>
</stripes:layout-render>