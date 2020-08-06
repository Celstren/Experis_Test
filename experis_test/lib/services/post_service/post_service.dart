import 'package:experis_test/data/model/post/post_model.dart';
import 'package:dio/dio.dart';
import 'package:experis_test/services/core/core.dart';
import 'package:flutter/material.dart';

class PostService {
  static String _baseURL = Core().server;
  static const String _postEndpoint = "posts";

  static Future<List<PostModel>> get requestAllPosts async {
    try {
      return (await Dio().get(_baseURL + _postEndpoint)).data.map<PostModel>((element) => PostModel.fromJson(element)).toList();
    } catch(e) {
      print("Error: $e");
      return [];
    }
  }
  static Future<PostModel> requestPost(int id) async {
    try {
      return PostModel.fromJson((await Dio().get(_baseURL + _postEndpoint + "/$id")).data);
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
  static Future<bool> sendPost(PostModel post) async {
    try {
      return (await Dio().post(_baseURL + _postEndpoint, data: post.toJson())).statusCode == 201;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
  static Future<bool> updatePost({@required int id, @required PostModel post}) async {
    try {
      return (await Dio().put(_baseURL + _postEndpoint + "/$id", data: post.toJson())).statusCode == 200;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
  static Future<bool> deletePost(int id) async {
    try {
      return (await Dio().delete(_baseURL + _postEndpoint + "/$id")).statusCode == 200;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}