import 'dart:convert';
import 'dart:developer';
import 'package:app_abesn_ppkd/models/screen_models/training_model.dart';
import 'package:app_abesn_ppkd/models/screen_models/batch_model.dart';
import 'package:app_abesn_ppkd/services/endpoint.dart';
import 'package:http/http.dart' as http;

class TrainingService {
  // ============================================================================
  // GET TRAINING LIST
  // ============================================================================
  static Future<List<Training>> getTraining() async {
    try {
      final response = await http.get(
        Uri.parse(Endpoint.trainings),
        headers: {"Accept": "application/json"},
      );

      log("STATUS TRAINING: ${response.statusCode}");
      log("BODY TRAINING: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data["data"] ?? [];
        return Training.listFromJson(list);
      } else {
        return [];
      }
    } catch (e) {
      log("ERROR SERVICE TRAINING: $e");
      return [];
    }
  }

  // ============================================================================
  // GET BATCH LIST
  // ============================================================================
  static Future<List<Batch>> getBatches() async {
    try {
      final response = await http.get(
        Uri.parse(Endpoint.batches),
        headers: {"Accept": "application/json"},
      );

      log("STATUS BATCH: ${response.statusCode}");
      log("BODY BATCH: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data["data"] ?? [];
        return list
            .map((e) => Batch.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      log("ERROR SERVICE BATCH: $e");
      return [];
    }
  }
}
