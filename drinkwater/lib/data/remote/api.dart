import 'dart:convert';

import 'package:dio/dio.dart';

/* 
        TODOs 
    1 - Cadastrar um usuário - OK
    2 - Realizar login do usuário - OK
    3 - Inserir os dados de um usuário - OK 
    4 - Modificar o email do usuário
    5 - Modificar a meta de consumo de água
    6 - Modificar a hora de acordar
    7 - Modificar a hora de dormir
    8 - Modificar o peso do usuário
    9 - Deletar os dados de um usuário
*/

class Api {
  Future<String> signUp(email, password) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['Content-Type'] = ' application/json';

    response = await dio.post(
        "https://parseapi.back4app.com/parse/functions/sign-up",
        data: {"email": email, "password": password});

    if (response.statusCode == 200) {
      return response.data['result'];
    } else {
      return 'Erro ao cadastrar usuário';
    }
  }

  Future<dynamic> login(email, password) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['Content-Type'] = ' application/json';

    response = await dio.post(
        "https://parseapi.back4app.com/parse/functions/login",
        data: {"email": email, "password": password});

    if (response.statusCode == 200) {
      return response.data['result'];
    } else {
      return response.statusMessage;
    }
  }

  Future<dynamic> logout(String? userToken) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/logout",
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }
}


/* class ControllersDataSourceRemoteImpl implements ApiRemoteDataSource {
  @override
  Future<List<BookDto>> getAllBooks() async {
    Response response;
    Dio dio = Dio();
    dio.options.headers['X-Parse-Application-Id'] =
        'mX7qL9mfiKCPhEgnWkmBXU6dcM9nkTkOXbvBpqV3';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'EDNEjUQlltCDcDB7kVxKjn2lkHG21hijexHbBlbk';
    dio.options.headers['Content-Type'] = ' application/json';

    response = await dio.post(
        "https://parseapi.back4app.com/parse/functions/get-list-book",
        data: '');
    if (response.statusCode == 200) {
      return BooksDto.fromJson(response.data).book as List<BookDto>;
    } else {
      return [];
    }
  }

  @override
  Future<bool> removeBook(bookId) async {
    Response response;
    Dio dio = Dio();
    dio.options.headers['X-Parse-Application-Id'] =
        'mX7qL9mfiKCPhEgnWkmBXU6dcM9nkTkOXbvBpqV3';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'EDNEjUQlltCDcDB7kVxKjn2lkHG21hijexHbBlbk';
    dio.options.headers['Content-Type'] = ' application/json';

    response = await dio.post(
        'https://parseapi.back4app.com/parse/functions/delete-book',
        data: {"bookId": bookId});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<String> createBook(BookEntity book) async {
    print(book.amount.runtimeType);
    print(book.amount);

    Response response;
    Dio dio = Dio();
    dio.options.headers['X-Parse-Application-Id'] =
        'mX7qL9mfiKCPhEgnWkmBXU6dcM9nkTkOXbvBpqV3';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'EDNEjUQlltCDcDB7kVxKjn2lkHG21hijexHbBlbk';
    dio.options.headers['Content-Type'] = ' application/json';

    response = await dio.post(
      'https://parseapi.back4app.com/parse/functions/create-book',
      data: {
        "title": book.title.toString(),
        "description": book.description.toString(),
        "author": book.author.toString(),
        "amount": 1,
      },
      options: Options(
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,
        // headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      log('Livro criado com sucesso');
      return 'Livro criado com sucesso';
    } else {
      log('Erro ao criar livro');
      return 'Erro ao criar livro';
    }
  }

  @override
  Future<bool> updateBook(BookDto book) async {
    Response responseBookUpdateTitle;
    Response responseBookUpdateAuthor;
    Response responseBookUpdateDescription;
    Response responseBookUpdateAmount;

    Dio dio = Dio();
    dio.options.headers['X-Parse-Application-Id'] =
        'mX7qL9mfiKCPhEgnWkmBXU6dcM9nkTkOXbvBpqV3';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'EDNEjUQlltCDcDB7kVxKjn2lkHG21hijexHbBlbk';
    dio.options.headers['Content-Type'] = ' application/json';

    responseBookUpdateTitle = await dio.post(
        "https://parseapi.back4app.com/parse/functions/edit-book-title",
        data: {
          "bookId": book.objectId,
          "title": book.title,
        });

    responseBookUpdateAuthor = await dio.post(
        "https://parseapi.back4app.com/parse/functions/edit-book-author",
        data: {"bookId": book.objectId, "author": book.author});

    responseBookUpdateDescription = await dio.post(
        "https://parseapi.back4app.com/parse/functions/edit-book-description",
        data: {"bookId": book.objectId, "description": book.description});

    responseBookUpdateAmount = await dio.post(
        "https://parseapi.back4app.com/parse/functions/edit-book-amount",
        data: {"bookId": book.objectId, "amount": book.amount});

    if (responseBookUpdateTitle.statusCode == 200 &&
        responseBookUpdateAuthor.statusCode == 200 &&
        responseBookUpdateDescription.statusCode == 200 &&
        responseBookUpdateAmount.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<BookEntity?> getBookDetails(String bookId) async {
    Response response;
    Dio dio = Dio();
    dio.options.headers['X-Parse-Application-Id'] =
        'mX7qL9mfiKCPhEgnWkmBXU6dcM9nkTkOXbvBpqV3';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'EDNEjUQlltCDcDB7kVxKjn2lkHG21hijexHbBlbk';
    dio.options.headers['Content-Type'] = ' application/json';

    response = await dio.post(
        'https://parseapi.back4app.com/parse/functions/get-book',
        data: {"bookId": bookId});
    if (response.statusCode == 200) {
      return BookDto.fromJson(response.data['result']);
    } else {
      return null;
    }
  }
}
 */