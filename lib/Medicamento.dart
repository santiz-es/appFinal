class Medicamento{
  int? id;
  String Nome;
  String Codigo;
  Medicamento({
    this.id,
    required this.Nome,
    required this.Codigo
  });

  Map<String, dynamic> toMap(){
    return{
      "id": id,
      "nome": Nome,
      "codigo": Codigo,
    };
  }

  factory Medicamento.fromMap(Map<String, dynamic>map){
    return Medicamento(
      id: map['id'],
      Nome: map['nome'],
      Codigo: map['codigo'],
    );
  }
}