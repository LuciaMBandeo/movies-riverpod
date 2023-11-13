abstract class IService<T> {
  Future<T> call({params});
}
