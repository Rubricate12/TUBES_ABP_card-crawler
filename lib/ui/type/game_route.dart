enum GameRoute {
  welcome('/'),
  mainMenu('/mainMenu'),
  gameplay('/gameplay');

  const GameRoute(this.path);
  final String path;
}
