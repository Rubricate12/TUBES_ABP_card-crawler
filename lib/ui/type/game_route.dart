enum GameRoute {
  welcomeMenu('/'),
  auth('/auth'),
  mainMenu('/menu'),
  gameplay('/gameplay');

  const GameRoute(this.path);
  final String path;
}
