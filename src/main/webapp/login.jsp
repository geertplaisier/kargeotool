<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/taglibs.jsp"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inloggen</title>
    </head>
    <body>
        <h2>Inloggen</h2>


        <form method="post" action="j_security_check">

            <table>
                <tr><td>Gebruikersnaam:</td><td><input type="text" name="j_username" /></td></tr>
                <tr><td>Wachtwoord:</td><td><input type="password" name="j_password"/></td></tr>
            </table>
			 <a type="button" href="/kargeotool/recover.html"> Wachtwoord vergeten?</a><br />
			 <a type="button" href="/kargeotool/recoverAccount.html"> Gebruikersnaam vergeten?</a>
            <p>
            <input type="submit" name="submit" value="Login"/>
        </form>
        <script type="text/javascript">
            window.onload = function() {
                document.forms[0].j_username.focus();
            }
        </script>
    </body>
</html>
