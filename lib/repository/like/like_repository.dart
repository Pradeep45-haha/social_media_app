import 'package:instagram_mmvm_dp_clone/config/data.dart';

abstract class LikeRepositoryAbs {
  Future<Data> getLikes();
  Future<Data> postLike();
  Future<Data> removeLike();
}
