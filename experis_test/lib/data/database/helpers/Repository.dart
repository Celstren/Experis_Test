abstract class Repository {
  Future<dynamic> insert(dynamic element);

  Future<int> insertList(List<dynamic> elements);

  Future<dynamic> update(dynamic element, {String id, String columnId = "id"});

  Future<dynamic> delete({String id, String columnId = "id"});

  Future<List<dynamic>> getAll();

  Future<dynamic> getById(String id, {String columnId = "id"});
}
