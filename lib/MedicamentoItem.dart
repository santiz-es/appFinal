import 'package:flutter/material.dart';
import 'package:appfinal/Medicamento.dart';

typedef OnDeleteCallback = void Function(int id);
typedef OnTapCallback = void Function(Medicamento medicamento);

class MedicamentoItem extends StatelessWidget {
  final Medicamento medicamento;
  final OnDeleteCallback onDelete;
  final OnTapCallback onTap;

  const MedicamentoItem({
    Key? key,
    required this.medicamento,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(medicamento.Nome),
      subtitle: Text(medicamento.Codigo),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => onDelete(medicamento.id!),
      ),
      onTap: () => onTap(medicamento),
    );
  }
}
