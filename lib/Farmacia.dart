class Farmacia {
  int? id;
  String nome;
  String cidade;  

  Farmacia({this.id, required this.nome, required this.cidade});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cidade': cidade,
    };
  }

  factory Farmacia.fromMap(Map<String, dynamic> map) {
    return Farmacia(
      id: map['id'],
      nome: map['nome'],
      cidade: map['cidade'],
    );
  }
}
