import 'package:flutter/material.dart';
import 'package:xlivros/models/livros_model.dart';
import 'package:xlivros/repository/historico_livros_repository.dart';
import 'package:xlivros/shared/app_images.dart';

class MeusLivrosPage extends StatefulWidget {
  const MeusLivrosPage({super.key});

  @override
  State<MeusLivrosPage> createState() => _MeusLivrosPageState();
}

class _MeusLivrosPageState extends State<MeusLivrosPage> {
  HistoricoLivrosRepository historicoRepository = HistoricoLivrosRepository();
  var _historico = const <LivrosModel>[];

  @override
  void initState() {
    super.initState();
    obterHistorico();
  }

  void obterHistorico() async {
    _historico = await historicoRepository.listarDados();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: RichText(
                text: const TextSpan(
                  style: TextStyle(
                      fontFamily: 'Arial Black',
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'M', // primeira letra em roxo
                      style: TextStyle(color: Colors.purple),
                    ),
                    TextSpan(text: 'EUS '),
                    TextSpan(
                      text: 'L', // primeira letra em roxo
                      style: TextStyle(color: Colors.purple),
                    ),
                    TextSpan(text: 'IVROS'), // restante em branco
                  ],
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.purple),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: ListView.builder(
                  itemCount: _historico.length,
                  itemBuilder: (BuildContext bc, int index) {
                    var hist = _historico[index];
                    return Card(
                      color: hist.lido == 1
                          ? Colors.lightGreen[100]
                          : Colors.red[100],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            color: Colors.black,
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              hist.nome,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: hist.imagem == "sem_foto"
                                ? CircleAvatar(
                                    backgroundImage: AssetImage(
                                      AppImages.xBlack,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      hist.imagem,
                                    ),
                                  ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Autores: ${hist.autor}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(
                                    height:
                                        8), // Espaçamento entre o título e o subtítulo
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        hist.data,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: GestureDetector(
                                          onTap: () async {
                                            String mensagem;
                                            if (hist.lido == 1) {
                                              await historicoRepository
                                                  .atualiza(0, hist.id);
                                              mensagem =
                                                  'O livro foi marcado como não lido.';
                                            } else {
                                              await historicoRepository
                                                  .atualiza(1, hist.id);
                                              mensagem =
                                                  'O livro foi marcado como lido.';
                                            }

                                            setState(() {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(mensagem),
                                                ),
                                              );

                                              hist.lido =
                                                  hist.lido == 1 ? 0 : 1;
                                            });
                                          },
                                          child: hist.lido == 1
                                              ? const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 24,
                                                )
                                              : const Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                  size: 24,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: TextButton(
                              onPressed: () async {
                                await historicoRepository.remover(hist.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Livro removido com sucesso."),
                                  ),
                                );
                                obterHistorico();
                              },
                              child: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            )));
  }
}
