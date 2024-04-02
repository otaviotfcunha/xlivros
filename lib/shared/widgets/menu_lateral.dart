import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xlivros/pages/meus_livros.dart';
import 'package:xlivros/shared/app_images.dart';
import 'package:xlivros/shared/widgets/itens_menu_lateral.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
                image: DecorationImage(
                    image: AssetImage(AppImages.logotipo),
                    fit: BoxFit.fitWidth),
              ),
              accountName: const Text(""),
              accountEmail: const Text("")),
          const ItensMenuLateral(
              textMenu: "Meus Livros",
              paginaDireciona: MeusLivrosPage(),
              iconeMenu: Icons.person),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          ItensMenuLateral(
              textMenu: "Sair",
              paginaDireciona: AlertDialog(
                title: const Text(
                  "Sair do Aplicativo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Wrap(
                  children: [
                    Text("Tem certeza que deseja sair do aplicativo?"),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Não")),
                  TextButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: const Text("Sim")),
                ],
              ),
              iconeMenu: Icons.exit_to_app),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
