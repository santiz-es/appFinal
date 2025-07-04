import 'package:appfinal/Farmacia.dart';
import 'package:appfinal/Farmacia_dao.dart';
import 'package:appfinal/Medicamento.dart';
import 'package:appfinal/Medicamento_dao.dart';
import 'package:appfinal/Relacion.dart';
import 'package:appfinal/Relacion_dao.dart';
import 'package:flutter/material.dart';

class Pag3 extends StatefulWidget {
  const Pag3({super.key});

  @override
  State<Pag3> createState() => _Pag3State();
}

class _Pag3State extends State<Pag3> {
  final medicamentoDAO = MedicamentoDao();
  final farmaciaDAO = FarmaciaDao();
  final relacionDAO = RelacionDao();

  List<Medicamento> medicamentos = [];
  List<Farmacia> farmacias = [];
  List<Relacion> relaciones = [];

  int? medicamentoSelecionadoId;
  int? farmaciaSelecionadaId;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final med = await medicamentoDAO.listarMedicamento();
    final far = await farmaciaDAO.listarFarmacia();
    final relacionList = await relacionDAO.listarRelacion();

    setState(() {
      medicamentos = med;
      farmacias = far;
      relaciones = relacionList;
    });
  }

  Future<void> _relacionar() async {
    if (medicamentoSelecionadoId == null || farmaciaSelecionadaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medicamento ou farmácia inválidos")),
      );
      return;
    }

    bool jaRelacionado = relaciones.any((r) =>
        r.medicamentoId == medicamentoSelecionadoId &&
        r.farmaciaId == farmaciaSelecionadaId);

    if (jaRelacionado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Medicamento já está relacionado nessa farmácia")),
      );
      return;
    }

    await relacionDAO.incluirRelacion(
      Relacion(
        medicamentoId: medicamentoSelecionadoId!,
        farmaciaId: farmaciaSelecionadaId!,
      ),
    );

    await _carregarDados();
  }

 Future<void> _desRelacionar(int medicamentoId, int farmaciaId) async {
  await relacionDAO.deleteRelacion(medicamentoId, farmaciaId);
  await _carregarDados();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relacionar medicamento em farmácia"),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<int>(
              hint: const Text("Selecione o medicamento"),
              isExpanded: true,
              value: medicamentoSelecionadoId,
              onChanged: (novo) {
                setState(() {
                  medicamentoSelecionadoId = novo;
                });
              },
              items: medicamentos.map((m) {
                return DropdownMenuItem<int>(
                  value: m.id,
                  child: Text("${m.Nome} (Código: ${m.Codigo})"),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            DropdownButton<int>(
              hint: const Text("Selecione a farmácia"),
              isExpanded: true,
              value: farmaciaSelecionadaId,
              onChanged: (novo) {
                setState(() {
                  farmaciaSelecionadaId = novo;
                });
              },
              items: farmacias.map((f) {
                return DropdownMenuItem<int>(
                  value: f.id,
                  child: Text(f.nome),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _relacionar,
              child: const Text("Relacionar"),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: relaciones.isEmpty
                  ? const Center(child: Text("Nenhuma relação encontrada"))
                  : ListView.builder(
                      itemCount: relaciones.length,
                      itemBuilder: (context, index) {
                        final r = relaciones[index];

                        final med = medicamentos.firstWhere(
                          (m) => m.id == r.medicamentoId,
                          orElse: () => Medicamento(
                              id: 0, Nome: "Desconhecido", Codigo: ""),
                        );

                        final far = farmacias.firstWhere(
                          (f) => f.id == r.farmaciaId,
                          orElse: () => Farmacia(
                              id: 0, nome: "Desconhecida", cidade: ""),
                        );

                        return ListTile(
                          title: Text(med.Nome),
                          subtitle: Text("Relacionado em: ${far.nome}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _desRelacionar(r.medicamentoId, r.farmaciaId),

                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
