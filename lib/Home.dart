import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// Modelo de Postagem
class Post {
  int userId;
  int id;
  String title;
  String body;

  Post(this.userId, this.id, this.title, this.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagens() async {
    Uri url = Uri.parse("$_urlBase/posts"); // Correção da URL
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var dadosJson = json.decode(response.body);
      List<Post> postagens = [];

      for (var post in dadosJson) {
        print("post: " + post["title"]);
        Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
        postagens.add(p);
      }
      return postagens;
    } else {
      throw Exception("Erro ao carregar postagens");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Consumo de serviço avançado")),
      body: FutureBuilder<List<Post>>(
        future: _recuperarPostagens(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());

            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text("Erro ao carregar os dados"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("Nenhuma postagem encontrada"));
              } else {
                List<Post> lista = snapshot.data!;
                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    Post post = lista[index];
                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text("ID: ${post.id}"),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
