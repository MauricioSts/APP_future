import 'package:app_consumo_servico_avancado/Post.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagens() async {
    Uri url = Uri.parse("$_urlBase/posts"); // Correção da concatenação
    http.Response response = await http.get(url);

    var dadosJson = json.decode(response.body);
    List<Post> postagens = [];

    for (var post in dadosJson) {
      print("post: " + post["title"]);
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);
    }
    return postagens;
  }

  _post() async {
    var corpo = json.encode({
      "userId": 120,
      "id": null,
      "title": "Titulo",
      "body": "Corpo da postagem",
    });

    Uri url = Uri.parse("$_urlBase/posts"); // Correção da concatenação
    http.Response response = await http.post(
      url,
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: corpo,
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
  }

  _put() {}

  _patch() {}

  _delete() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Consumo de serviço avançado")),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ElevatedButton(child: Text("Salvar"), onPressed: _post),
                ElevatedButton(child: Text("Atualizar"), onPressed: _post),
                ElevatedButton(child: Text("Remover"), onPressed: _post),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _recuperarPostagens(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        print("lista: Erro ao carregar ");
                        return Center(child: Text("Erro ao carregar os dados"));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            List<Post> lista = snapshot.data!;
                            Post post = lista[index];

                            return ListTile(
                              title: Text(post.title),
                              subtitle: Text(post.id.toString()),
                            );
                          },
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
