import 'package:instagram_mmvm_dp_clone/config/data.dart';

abstract class SaveRepositoryAbs {
  Future<Data> getSavedPosts();
  Future<Data> savePost();
  Future<Data> removeSavedPost();
}
