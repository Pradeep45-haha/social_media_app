import 'package:instagram_mmvm_dp_clone/config/data.dart';

abstract class PostRepositoryAbs {
  Future<Data> getPosts();
  Future<Data> createPost();
  Future<Data> removePost();
  Future<Data> updatePost();
}
