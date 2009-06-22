<%@include file="/WEB-INF/taglibs.jsp" %>
<%@page errorPage="/WEB-INF/jsp/commons/errorpage.jsp" %>

<%@page pageEncoding="UTF-8"%>

<tiles:importAttribute/>

<html:html>
    <head>
        <title><fmt:message key="index.title"/></title>
        <script language="JavaScript" type="text/JavaScript" src="<html:rewrite page="/js/validation.jsp" module=""/>"></script>
        <link rel="stylesheet" href="<html:rewrite page="/styles/geo-ov.css" module=""/>" type="text/css" media="screen" />
        <!--[if lte IE 6]>
            <link href="<html:rewrite page="/styles/geo-ov-ie6.css" module=""/>" rel="stylesheet" media="screen" type="text/css" />
            <script type="text/javascript" src="<html:rewrite page="/js/ie6fixes.js" module=""/>"></script>
        <![endif]-->
        <!--[if IE 7]> <link href="<html:rewrite page="/styles/geo-ov-ie7.css" module=""/>" rel="stylesheet" media="screen" type="text/css" /> <![endif]-->
    </head>
    <body>
        <div id="headerbg">
            <div id="headerTitle">Geo OV platform</div>
        </div>
        <div id="contentcontainer">
            <tiles:insert name='content'/>
        </div>
    </body>
</html:html>