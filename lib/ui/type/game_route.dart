enum GameRoute {
  welcome('/'),
  mainMenu('/main-menu'),
  gameplay('/gameplay');

  const GameRoute(this.path);
  final String path;
}
