abstract class BaseAuthApi {
  Future login(String code);
  Future info();
  Future refresh();
}
