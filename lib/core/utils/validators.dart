class Validators {
  const Validators._();

  static bool isValidBpm(int value) => value > 0 && value < 300;
}
