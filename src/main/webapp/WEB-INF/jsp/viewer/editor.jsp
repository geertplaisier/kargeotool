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

    <stripes:layout-component name="head">
        <script type="text/javascript" src="${contextPath}/js/proj4js/proj4js-compressed.js"></script>
        <script type="text/javascript">
            Proj4js.defs["EPSG:28992"] = "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.237,50.0087,465.658,-0.406857,0.350733,-1.87035,4.0812 +units=m +no_defs";
            Proj4js.defs["EPSG:4236"] = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ";
        </script>
    </stripes:layout-component>
    <stripes:layout-component name="headerlinks" >
        <%@include file="/WEB-INF/jsp/commons/headerlinks.jsp" %>

    </stripes:layout-component>
    <stripes:layout-component name="content">


        <script type="text/javascript">
            var profile = {};

            <c:if test="${!empty actionBean.gebruiker.profile}">
                profile = ${actionBean.gebruiker.profile};
            </c:if>
        </script>

        <script type="text/javascript" src="${contextPath}/js/profilestate.js"></script>
        <script type="text/javascript" src="${contextPath}/js/karattributes.js"></script>
        <script type="text/javascript" src="${contextPath}/js/forms.js"></script>
        <script type="text/javascript" src="${contextPath}/js/settings.js"></script>
        <script type="text/javascript" src="${contextPath}/js/welcome.js"></script>
        <script type="text/javascript" src="${contextPath}/js/editor.js"></script>
        <script type="text/javascript" src="${contextPath}/js/layout.js"></script>
        <script type="text/javascript" src="${contextPath}/js/TreeCombo.js"></script>
        <script type="text/javascript" src="${contextPath}/js/overview.js"></script>
        <script type="text/javascript" src="${contextPath}/js/messagesOverview.js"></script>
        <script type="text/javascript" src="${contextPath}/js/rtree.js"></script> <!-- Possibly later rtree.min.js, for now some edits/bugfixes are made in rtree.js, which are not in the minified version -->

        <div id="leftbar">

            <div id="searchform" style="margin: 3px"></div>

            <div id="rseqInfoPanel">
                <div id="overzichtTitel">
                    Huidig geselecteerde VRI: <span id="context_vri"></span><img id="memo_vri" src="${contextPath}/images/silk/attach.png" OnMouseOut="this.style.cursor='default';" OnMouseOver="this.style.cursor='pointer';" style="visibility: hidden;" onclick="editor.addMemo();"/>
                </div>
                <div id="overzicht" style="margin-top: 5px; font-size: 10pt"></div>
                <div id="rseqOptions" style="visibility: hidden">
                    <input type="button" id="rseqSave" value="Opslaan" onclick="editor.saveOrUpdate();">
                    <span id="validationResults"></span>
                </div>
            </div>

            <div id="form" style="margin: 3px">
                <div id="help">
                    Klik op een icoon van een verkeerssysteem om deze te selecteren
                    of klik rechts om een verkeerssysteem toe te voegen.
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
                    <b>Verkeerssystemen</b><br/>
                    <img src="<c:url value="/images/"/>icons/vri.png" alt="VRI" class="legendimg" /> VRI<br />
                    <img src="<c:url value="/images/"/>icons/wri.png" alt="Waarschuwingssysteem" class="legendimg" /> Waarschuwingssysteem<br />
                    <img src="<c:url value="/images/"/>icons/afsluitingssysteem.png" alt="Afsluitingssysteem" class="legendimg" /> Afsluitingssysteem<br />
                    <img src="<c:url value="/images/"/>icons/cluster.png" alt="Meerdere verkeersystemen" class="legendimg" /> Meerdere verkeersystemen<br />
                    <b>Filters</b><br/>
                    <label><input type="checkbox" id="kv9valid" onclick="setFilter('kv9', 'valid');"/>KV9 validatie OK</label><br/>
                    <label><input type="checkbox" id="kv9invalid" onclick="setFilter('kv9','invalid');"/>KV9 validatie niet OK</label><br/>
                    <label><input type="checkbox" id="layerOV" onclick="setFilter('layer','OV');"/>OV</label><br/>
                    <label><input type="checkbox" id="layerHulpdiensten" onclick="setFilter('layer','Hulpdiensten');"/>Hulpdiensten</label><br/>

                </div>
                <div id="triggerpunten" class="legendseparator">
                    <b>Punten</b><br/>
                    <img src="<c:url value="/images/"/>/icons/radio_zwart.png" alt="Onbekend" class="legendimg" /> Onbekend<br />
                    <img src="<c:url value="/images/"/>/icons/radio_groen.png" alt="Inmeldpunt" class="legendimg" /> Inmeldpunt<br />
                    <img src="<c:url value="/images/"/>/icons/radio_rood.png" alt="Uitmeldpunt" class="legendimg" /> Uitmeldpunt<br />
                    <img src="<c:url value="/images/"/>/icons/radio_blauw.png" alt="Voorinmeldpunt" class="legendimg" /> Voorinmeldpunt<br />
                </div>
                <div id="starteindpunten" class="legendseparator">
                    <b>Begin- en eindpunten</b><br/>
                    <img src="<c:url value="/images/"/>/icons/beginpunt.png" alt="Beginpunt" class="legendimg" /> Beginpunt<br />
                    <img src="<c:url value="/images/"/>/icons/eindpunt.png" alt="Eindpunt" class="legendimg" /> Eindpunt<br />
                </div><br/>
                <b>OV-informatie</b><br/>
                <input type="checkbox" id="buslijnen_visible" onclick="toggleOvInfoLayer(event);"/><img src="${initParam['mapserver-url']}&amp;version=1.1.1&amp;service=WMS&amp;request=GetLegendGraphic&amp;layer=buslijnen&amp;format=image/png"/> Buslijnen<br/>
                <div style="display: none;margin-left: 15px;" id="buslijnen_filter"><a href="#" id="buslijnen_filter_a" onclick='removeFilter();'>Verwijder filter</a></div>
                <input type="checkbox" id="bushaltes_visible" onclick="toggleOvInfoLayer(event);"/><img src="${initParam['mapserver-url']}&amp;version=1.1.1&amp;service=WMS&amp;request=GetLegendGraphic&amp;layer=bushaltes_symbol&amp;format=image/png"/> Bushaltes<br/>
                <div style="display:block;" id="bushaltes"></div><br/>
                <b>Achtergrond</b><br/>
                <div id="Luchtfoto_div" style="width: 90%; height: 38px">
                    <input type="checkbox" id="Luchtfoto_visible" onclick="toggleLayer(event);"/> Luchtfoto<br/>
                </div>
                <div id="Openbasiskaart_div" style="width: 90%; height: 38px">
                    <input type="checkbox" id="Openbasiskaart_visible" onclick="toggleLayer(event);"/> Topografie (OSM)<br/>
                </div>
                <br/>
                <b>Extra</b><br/>
                <input type="checkbox" id="snapRoads" onclick="toggleRoad(this);"/> Wegen<br/>
            </div>


            <script type="text/javascript">
                var mapfilePath = "${initParam['mapserver-url']}&schema={0}";

                var editorActionBeanUrl = "<stripes:url beanclass="nl.b3p.kar.stripes.EditorActionBean" />";
                var searchActionBeanUrl = "<stripes:url beanclass="nl.b3p.kar.stripes.SearchActionBean"/>";
                var profileActionBeanUrl = "<stripes:url beanclass="nl.b3p.kar.stripes.ProfileActionBean"/>";
                var exportActionBeanUrl = "<stripes:url beanclass="nl.b3p.kar.stripes.ExportActionBean"/>";
                var usersActionBeanUrl = "<stripes:url beanclass="nl.b3p.kar.stripes.GebruikersActionBean"/>";

                var contextPath = "${contextPath}";
                var editor = null;
                var settingsForm = null;
                var welcomeForm = null;
                Ext.onReady(function() {

                    var checkboxes = ['buslijnen', 'bushaltes', 'Luchtfoto', 'Openbasiskaart'];
                    Ext.Array.each(checkboxes, function(checkbox) {
                        Ext.get(checkbox + "_visible").dom.checked = getLayerVisibility(checkbox);
                    });

                    Ext.get("kv9valid").dom.checked = profile.state["kv9valid"] !== undefined ? profile.state["kv9valid"] : true;
                    Ext.get("kv9invalid").dom.checked = profile.state["kv9invalid"] !== undefined ? profile.state["kv9invalid"] : true;

                    Ext.get("layerOV").dom.checked = profile.state["layerOV"] !== undefined ? profile.state["layerOV"] : true;
                    Ext.get("layerHulpdiensten").dom.checked = profile.state["layerHulpdiensten"] !== undefined ? profile.state["layerHulpdiensten"] : true;

                    createLegendSliders();

                    editor = Ext.create(Editor, "map", mapfilePath, ovInfo);

                    settingsForm = Ext.create(SettingsForm, editor);
                    var disabledDefaults = [0,3,4,7,8,9,11,15,16,17,19,20,21,22,23];
                    if(!profile.defaultKarAttributes) {
                        profile.defaultKarAttributes = { "ES": [ [], [], [] ], "PT": [ [], [], [] ], "OT": [ [], [], [] ]};
                        var vts = ["ES","PT","OT"];
                        for(var i in vts) {
                            var vt = vts[i];
                            for(var j = 0; j < 24; j++) {
                                if(!Ext.Array.contains(disabledDefaults,j)){
                                    profile.defaultKarAttributes[vt][0].push(true);
                                    profile.defaultKarAttributes[vt][1].push(true);
                                    profile.defaultKarAttributes[vt][2].push(true);
                                }else{
                                    profile.defaultKarAttributes[vt][0].push(false);
                                    profile.defaultKarAttributes[vt][1].push(false);
                                    profile.defaultKarAttributes[vt][2].push(false);

                                }
                            }
                        }
                    }

                    if(profile.firstRun == undefined || profile.firstRun ) {
                        showWelcome();
                    }
                });

                function showWelcome() {
                    if(welcomeForm == null) {
                        welcomeForm = Ext.create(WelcomeForm);
                    }
                    welcomeForm.show();
                }

                var vehicleTypes = ${actionBean.vehicleTypesJSON};
                var dataOwners = ${actionBean.dataOwnersJSON};
                var ovInfo = ${actionBean.ovInfoJSON};

                function getLayerOpacity(layer) {
                    return profile.state[layer + "_slider"] / 100.0 || 1;
                }

                function getLayerVisibility(layer) {
                    var state = profile.state[layer + "_visible"];
                    if(state == undefined) {
                        return layer == "Openbasiskaart";
                    } else {
                        return state;
                    }
                }

                function getFilterStatus(prefix,type) {
                    return Ext.get(prefix + type).dom.checked;
                }

                function createLegendSliders() {

                    var changeFunc = function(slider, newValue, thumb, eOpts) {
                        profile.state[slider.id] = newValue;
                        saveProfile();
                        editor.setLayerOpacity(slider.id.substr(0, slider.id.indexOf('_')), newValue / 100.0);
                    };
                    Ext.create('Ext.slider.Single', {
                        id: 'Luchtfoto_slider',
                        renderTo: 'Luchtfoto_div',
                        hideLabel: true,
                        useTips: true,
                        width: '100%',
                        style: {
                            marginLeft: '15px'
                        },
                        value: getLayerOpacity("Luchtfoto") * 100,
                        increment: 10,
                        minValue: 0,
                        maxValue: 100,
                        listeners: {
                            change: changeFunc
                        }
                    });

                    Ext.create('Ext.slider.Single', {
                        id: 'Openbasiskaart_slider',
                        renderTo: 'Openbasiskaart_div',
                        hideLabel: true,
                        useTips: true,
                        width: '100%',
                        style: {
                            marginLeft: '15px'
                        },
                        value: getLayerOpacity("Openbasiskaart") * 100,
                        increment: 10,
                        minValue: 0,
                        maxValue: 100,
                        listeners: {
                            change: changeFunc
                        }
                    });
                }

                function toggleOvInfoLayer(event) {
                    if(!event) {
                        event = window.event;
                    }
                    var target = event.target ? event.target : event.srcElement;

                    var layer = target.id.substr(0, target.id.indexOf('_'));
                    var visible = target.checked;

                    Ext.Array.each(ovInfo, function(ov) {
                        editor.olc.setLayerVisible(layer + "_" + ov.schema, visible);
                    });

                    profile.state[layer + "_visible"] = visible;
                    saveProfile();
                }

                function toggleLayer(event) {
                    if(!event) {
                        event = window.event;
                    }
                    var target = event.target ? event.target : event.srcElement;

                    var layer = target.id.substr(0, target.id.indexOf('_'));
                    var visible = target.checked;

                    editor.olc.setLayerVisible(layer, visible);
                    profile.state[layer + "_visible"] = visible;
                    saveProfile();
                }

                function setFilter(prefix, type) {
                    var checked = Ext.get(prefix + type).dom.checked;

                    editor.updateFilteredRseqs();
                    profile.state[prefix + type] = checked;
                    saveProfile();
                }

                function toggleRoad(form){
                    var activate = form.checked;
                    if(activate){
                        editor.loadRoads();
                    }else{
                        editor.removeRoads();
                    }
                }

                function removeFilter(){
                    Ext.Array.each(ovInfo, function(ov) {
                        var currentName = "buslijnen_" + ov.schema;

                        // Prevent old image from showing
                        editor.olc.setLayerVisible(currentName, false);
                        editor.olc.removeFilterFromKargis(currentName);
                        editor.olc.setLayerVisible(currentName, true);
                    });

                    Ext.get("buslijnen_filter").setDisplayed(false);
                }
            </script>
        </div>

    </stripes:layout-component>
</stripes:layout-render>