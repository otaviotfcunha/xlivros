import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xlivros/models/livros_model.dart';
import 'package:xlivros/repository/historico_livros_repository.dart';
import 'package:xlivros/shared/app_images.dart';
import 'package:xlivros/shared/widgets/menu_lateral.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  HistoricoLivrosRepository livrosRepository = HistoricoLivrosRepository();
  List<dynamic> _searchResults = [];

  Future<void> _searchBooks(String query) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = jsonDecode(response.body)['items'];
      });
    } else {
      throw Exception('Falha ao carregar os livros...');
    }
  }

  void _adicionarLivroHistorico(dynamic book) async {
    try {
      String datahoje = DateTime.now().toString();
      String linkLivro = "";

      if (book['volumeInfo']['imageLinks'] == null) {
        linkLivro = "sem_foto";
      } else {
        linkLivro = book['volumeInfo']['imageLinks']['thumbnail'];
      }
      LivrosModel livro = LivrosModel(
        0,
        book['volumeInfo']['title'].toString(),
        book['volumeInfo']['authors'] != null
            ? book['volumeInfo']['authors'].join(', ')
            : 'Autor Desconhecido',
        datahoje,
        linkLivro,
        0,
      );
      await livrosRepository.salvar(livro);

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Sucesso"),
          content:
              const Text("O livro foi adicionado à sua lista de leituras."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erro"),
          content: Text("Erro: ${e.toString()}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Image(image: AssetImage(AppImages.logotipo)),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.purple, // Defina a cor do ícone aqui
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: const MenuLateral(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Procurar Livros',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                String query = _searchController.text;
                _searchBooks(query);
              },
              child: const Text('Procurar'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  dynamic book = _searchResults[index];
                  return Card(
                    child: ListTile(
                      leading: book['volumeInfo']['imageLinks'] == null
                          ? Image.asset(
                              AppImages.logotipoBlack,
                              width: 50,
                              height: 75,
                              fit: BoxFit.fitWidth,
                            )
                          : Image.network(
                              book['volumeInfo']['imageLinks']['thumbnail'],
                              width: 50,
                              height: 75,
                              fit: BoxFit.cover,
                            ),
                      title: Text(book['volumeInfo']['title']),
                      subtitle: Text(book['volumeInfo']['authors'] != null
                          ? book['volumeInfo']['authors'].join(', ')
                          : 'Sem autor'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          _adicionarLivroHistorico(book);
                        },
                      ),
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
