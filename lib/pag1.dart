import 'package:appfinal/ApiService.dart';
import 'package:appfinal/Medicamento.dart';
import 'package:appfinal/MedicamentoItem.dart';
import 'package:appfinal/Medicamento_dao.dart';
import 'package:flutter/material.dart';

class Pag1 extends StatefulWidget {
  const Pag1({super.key});

  @override
  State<Pag1> createState() => _Pag1State();
}

class _Pag1State extends State<Pag1> {
  final apiService = ApiService();
  final _medicamentoDAO = MedicamentoDao();

  Medicamento? _medicamentoAtual;
  final _controllerNome = TextEditingController();
  final _controllerCodigo = TextEditingController();

  List<Medicamento> _listMedicamento = [];
  List<Medicamento> _listApiMedicamento = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarMedicamentosLocais();
    _carregarMedicamentosDaApi();
  }

  Future<void> _carregarMedicamentosLocais() async {
    List<Medicamento> medsLocal = await _medicamentoDAO.listarMedicamento();
    setState(() {
      _listMedicamento = medsLocal;
    });
  }

  Future<void> _carregarMedicamentosDaApi() async {
    setState(() => _isLoading = true);
    try {
      List<Medicamento> medsApi = await apiService.buscarMedicamentos();
      setState(() {
        _listApiMedicamento = medsApi;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar API: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _salvarOUEditar() async {
    if (_medicamentoAtual == null) {
      await _medicamentoDAO.incluirMedicamento(
        Medicamento(
          Nome: _controllerNome.text,
          Codigo: _controllerCodigo.text,
        ),
      );
    } else {
      _medicamentoAtual!.Nome = _controllerNome.text;
      _medicamentoAtual!.Codigo = _controllerCodigo.text;
      await _medicamentoDAO.editarMedicamento(_medicamentoAtual!);
    }
    _controllerNome.clear();
    _controllerCodigo.clear();
    _medicamentoAtual = null;
    await _carregarMedicamentosLocais();
  }

  Future<void> _apagarMedicamento(int id) async {
    await _medicamentoDAO.deleteMedicamento(id);
    await _carregarMedicamentosLocais();
  }

  Future<void> _salvarMedicamentoDaApi(Medicamento med) async {
    await _medicamentoDAO.incluirMedicamento(med);
    await _carregarMedicamentosLocais();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Medicamento salvo localmente!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD Medicamento"),
        backgroundColor: Colors.cyan,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                MedicamentoForm(
                  nomeController: _controllerNome,
                  codigoController: _controllerCodigo,
                  onSave: _salvarOUEditar,
                  isEditing: _medicamentoAtual != null,
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Medicamentos Locais", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _listMedicamento.length,
                    itemBuilder: (context, index) {
                      return MedicamentoItem(
                        medicamento: _listMedicamento[index],
                        onDelete: _apagarMedicamento,
                        onTap: (med) {
                          setState(() {
                            _medicamentoAtual = med;
                            _controllerNome.text = med.Nome;
                            _controllerCodigo.text = med.Codigo;
                          });
                        },
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Medicamentos da API", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _listApiMedicamento.length,
                    itemBuilder: (context, index) {
                      final med = _listApiMedicamento[index];
                      return ListTile(
                        title: Text(med.Nome),
                        subtitle: Text("Código: ${med.Codigo}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () => _salvarMedicamentoDaApi(med),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class MedicamentoForm extends StatelessWidget {
  final TextEditingController nomeController;
  final TextEditingController codigoController;
  final VoidCallback onSave;
  final bool isEditing;

  const MedicamentoForm({
    required this.nomeController,
    required this.codigoController,
    required this.onSave,
    required this.isEditing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              labelText: "Nome",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: codigoController,
            decoration: const InputDecoration(
              labelText: "Código",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSave,
              child: Text(isEditing ? "Atualizar" : "Salvar"),
            ),
          ),
        ),
      ],
    );
  }
}