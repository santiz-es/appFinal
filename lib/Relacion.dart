class Relacion {
  int medicamentoId;
  int farmaciaId;

  Relacion({
    required this.medicamentoId,
    required this.farmaciaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_medicamento': medicamentoId,
      'id_farmacia': farmaciaId,
    };
  }

  factory Relacion.fromMap(Map<String, dynamic> map) {
    return Relacion(
      medicamentoId: map['id_medicamento'],
      farmaciaId: map['id_farmacia'],
    );
  }
}
