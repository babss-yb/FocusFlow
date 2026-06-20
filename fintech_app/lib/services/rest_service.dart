import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';

/// Service pour consommer l'API REST Node.js Prisma
class RestApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  // ─── PROJETS ────────────────────────────────────────────────────────

  /// GET : Récupérer les projets
  Future<List<Project>> getProjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/projects'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Project.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors du chargement des projets');
      }
    } catch (e) {
      throw Exception('Erreur de connexion REST : $e');
    }
  }

  /// POST : Ajouter un projet
  Future<Project> addProject(Project project) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/projects'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'title': project.title,
          'description': project.description,
          'userId': project.userId,
        }),
      );
      if (response.statusCode == 201) {
        return Project.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erreur lors de la création du projet');
      }
    } catch (e) {
      throw Exception('Erreur de connexion REST : $e');
    }
  }

  /// PUT : Modifier un projet
  Future<Project> updateProject(Project project) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/projects/${project.id}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'title': project.title,
          'description': project.description,
        }),
      );
      if (response.statusCode == 200) {
        return Project.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erreur lors de la mise à jour du projet');
      }
    } catch (e) {
      throw Exception('Erreur de connexion REST : $e');
    }
  }

  /// DELETE : Supprimer un projet
  Future<bool> deleteProject(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/projects/$id'));
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Erreur de connexion REST : $e');
    }
  }

  // ─── TÂCHES ─────────────────────────────────────────────────────────

  /// GET : Récupérer les tâches (Mock pour le backend Node.js non implémenté)
  Future<List<ProjectTask>> getTasks() async {
    return []; // Pas encore de tâches côté Prisma
  }
}
