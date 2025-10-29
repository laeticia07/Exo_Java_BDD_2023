<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.time.LocalDate" %>

<html>
<head>
<title>Gestion des Tâches</title>
</head>
<body bgcolor="white">
<h1>Mini Gestionnaire de Tâches</h1>

<!-- Formulaire d'ajout -->
<form action="#" method="post">
    <label for="titre">Titre :</label><br>
    <input type="text" id="titre" name="titre" required><br><br>

    <label for="desc">Description :</label><br>
    <textarea id="desc" name="description" required></textarea><br><br>

    <label for="date">Date d’échéance :</label><br>
    <input type="date" id="date" name="dateEcheance" required><br><br>

    <input type="submit" name="ajouter" value="Ajouter la tâche">
</form>

<%! 
    // ----- Classe représentant une tâche -----
    public class Tache {
        String titre;
        String description;
        LocalDate dateEcheance;
        boolean terminee;

        public Tache(String titre, String description, LocalDate dateEcheance) {
            this.titre = titre;
            this.description = description;
            this.dateEcheance = dateEcheance;
            this.terminee = false;
        }
    }
%>

<%
    // ----- Liste stockée en session -----
    ArrayList<Tache> listeTaches = (ArrayList<Tache>) session.getAttribute("listeTaches");
    if (listeTaches == null) {
        listeTaches = new ArrayList<Tache>();
        session.setAttribute("listeTaches", listeTaches);
    }

    // ----- Ajout -----
    if (request.getParameter("ajouter") != null) {
        String titre = request.getParameter("titre");
        String description = request.getParameter("description");
        String dateStr = request.getParameter("dateEcheance");

        if (titre != null && description != null && dateStr != null && !titre.isEmpty()) {
            LocalDate date = LocalDate.parse(dateStr);
            listeTaches.add(new Tache(titre, description, date));
        }
    }

    // ----- Suppression -----
    if (request.getParameter("supprimer") != null) {
        int index = Integer.parseInt(request.getParameter("supprimer"));
        if (index >= 0 && index < listeTaches.size()) {
            listeTaches.remove(index);
        }
    }

    // ----- Marquer comme terminée -----
    if (request.getParameter("terminer") != null) {
        int index = Integer.parseInt(request.getParameter("terminer"));
        if (index >= 0 && index < listeTaches.size()) {
            listeTaches.get(index).terminee = true;
        }
    }
%>

<hr>
<h2>Liste des tâches</h2>

<table border="1" cellpadding="8">
    <tr style="background-color:#f0f0f0;">
        <th>#</th>
        <th>Titre</th>
        <th>Description</th>
        <th>Date d’échéance</th>
        <th>Statut</th>
        <th>Actions</th>
    </tr>

    <%
        for (int i = 0; i < listeTaches.size(); i++) {
            Tache t = listeTaches.get(i);
    %>
    <tr bgcolor="<%= t.terminee ? "#ccffcc" : "white" %>">
        <td><%= i + 1 %></td>
        <td><%= t.titre %></td>
        <td><%= t.description %></td>
        <td><%= t.dateEcheance %></td>
        <td><%= t.terminee ? "✅ Terminée" : "⏳ En cours" %></td>
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
