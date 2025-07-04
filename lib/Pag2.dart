import 'package:appfinal/Farmacia.dart';
import 'package:appfinal/Farmacia_dao.dart';
import 'package:flutter/material.dart';


class Pag2 extends StatefulWidget {
  const Pag2({super.key});

  @override
  State<Pag2> createState() => _Pag2State();
}

class _Pag2State extends State<Pag2> {
  final _farmaciaDAO = FarmaciaDao();
  Farmacia? _farmaciaAtual;
  final _controllerNome = TextEditingController();
  final _controllerCidade = TextEditingController();
  List<Farmacia> _listFarmacias = [];

  @override
  void initState() {
    super.initState();
    _loadFarmacias();
  }

  Future<void> _loadFarmacias() async {
    List<Farmacia> temp = await _farmaciaDAO.listarFarmacia();
    setState(() {
      _listFarmacias = temp;
    });
  }

  Future<void> _salvarOUEditar() async {
    if (_farmaciaAtual == null) {
      await _farmaciaDAO.incluirFarmacia(
        Farmacia(
          nome: _controllerNome.text,
          cidade: _controllerCidade.text,
        ),
      );
    } else {
      _farmaciaAtual!.nome = _controllerNome.text;
      _farmaciaAtual!.cidade = _controllerCidade.text;
      await _farmaciaDAO.editarFarmacia(_farmaciaAtual!);
    }
    _controllerNome.clear();
    _controllerCidade.clear();
    setState(() {
      _farmaciaAtual = null;
    });
    await _loadFarmacias();
  }

  Future<void> _apagarFarmacia(int id) async {
    await _farmaciaDAO.deleteFarmacia(id);
    await _loadFarmacias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD Farmacia"),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _controllerNome,
              decoration: InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _controllerCidade,
              decoration: InputDecoration(
                labelText: "Cidade",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: _salvarOUEditar,
                child: _farmaciaAtual == null ? Text("Salvar") : Text("Atualizar"),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listFarmacias.length,
              itemBuilder: (context, index) {
                final Farmacia = _listFarmacias[index];
                return ListTile(
                  title: Text(Farmacia.nome),
                  subtitle: Text(Farmacia.cidade),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _apagarFarmacia(Farmacia.id!);
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _farmaciaAtual = Farmacia;
                      _controllerNome.text = Farmacia.nome;
                      _controllerCidade.text = Farmacia.cidade;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
