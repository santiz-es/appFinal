import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appfinal/Medicamento.dart';

class ApiService {
  final String baseUrl = "https://hapi.fhir.org/baseR4";

  Future<List<Medicamento>> buscarMedicamentos() async {
    final response = await http.get(Uri.parse('$baseUrl/Medication?_count=10'));

    if (response.statusCode == 200) {
      Map<String, dynamic> dados = jsonDecode(response.body);
      List results = dados['entry'] ?? [];

      return results.map((json) {
        final med = json['resource'];
        return Medicamento(
          id: 0, 
          Nome: med['code']?['text'] ?? 'Sem nome',
          Codigo: med['id'] ?? 'sem-codigo',
        );
      }).toList();
    } else {
      throw Exception('Erro ao buscar medicamentos da API');
    }
  }
}
