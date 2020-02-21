class Contato {
  int id;
  String nome;
  String telefone;
  String email;
  String imagem;

  Contato({this.nome, this.telefone, this.email, this.imagem});

  Contato.fromMap(Map map) {
    id = map['id'];
    nome = map['nome'];
    telefone = map['telefone'];
    email = map['email'];
    imagem = map['imagem'];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      'nome'    : nome,
      'telefone': telefone,
      'email'   : email,
      'imagem'  : imagem,
    };
    if (id != null) map['id'] = id;

    return map;
  }

  @override
  String toString() {
    return 'Contato[ id: $id, nome: $nome, telefone: $telefone, email: $email, imagem: $imagem]';
  }
}
