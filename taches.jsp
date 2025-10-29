<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.time.LocalDate"%>

<html>
<head><title>Gestionnaire de Tâches</title></head>
<body>

<h1>Gestionnaire de Tâches</h1>

<form method="post">
  Titre : <input name="titre" required><br><br>
  Description : <input name="desc" required><br><br>
  Date : <input type="date" name="date" required><br><br>
  <input type="submit" name="ajouter" value="Ajouter">
</form>

<%! 
class Tache {
  String titre;
  String desc;
  LocalDate date;
  boolean terminee = false;

  Tache(String t, String d, LocalDate dt) {
    titre = t;
    desc = d;
    date = dt;
  }
}
%>

<%
request.setCharacterEncoding("UTF-8");
ArrayList<Tache> taches = (ArrayList<Tache>) session.getAttribute("taches");
if (taches == null) {
  taches = new ArrayList<Tache>();
  session.setAttribute("taches", taches);
}

if (request.getParameter("ajouter") != null) {
  taches.add(new Tache(
    request.getParameter("titre"),
    request.getParameter("desc"),
    LocalDate.parse(request.getParameter("date"))
  ));
}

if (request.getParameter("supprimer") != null) {
  taches.remove(Integer.parseInt(request.getParameter("supprimer")));
}

if (request.getParameter("terminer") != null) {
  taches.get(Integer.parseInt(request.getParameter("terminer"))).terminee = true;
}
%>

<hr>
<table border="1" cellpadding="5">
<tr><th>#</th><th>Titre</th><th>Description</th><th>Date</th><th>Statut</th><th>Actions</th></tr>
<%
for (int i = 0; i < taches.size(); i++) {
  Tache t = taches.get(i);
%>
<tr bgcolor="<%= t.terminee ? "#ccffcc" : "white" %>">
  <td><%= i + 1 %></td>
  <td><%= t.titre %></td>
  <td><%= t.desc %></td>
  <td><%= t.date %></td>
  <td><%= t.terminee ? "Terminée" : "En cours" %></td>
  <td>
    <% if (!t.terminee) { %>
      <a href="?terminer=<%= i %>">Terminer</a>
    <% } %>
    <a href="?supprimer=<%= i %>">Supprimer</a>
  </td>
</tr>
<% } %>
</table>

</body>
</html>
