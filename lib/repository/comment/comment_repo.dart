import 'package:instagram_mmvm_dp_clone/config/data.dart';

abstract class CommentRepositoryAbs {
  Future<Data> getComments();
  Future<Data> postComment();
  Future<Data> updateComment();
  Future<Data> removeComment();
}
