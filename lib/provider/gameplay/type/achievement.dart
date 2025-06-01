enum Achievement {
  firstStep(0, 'First Step', 'Play the game for the first time'),
  niceTry(1, 'Nice Try', 'Lose a run for the first time'),
  gottaDash(2, 'Gotta Dash', 'Run away for the first time'),
  dungeonCrawler(3, 'Dungeon Crawler', 'Finish the game'),
  soClose(4, 'So Close...', 'Lose the game without any cards left in the deck'),
  perfectAdventurer(5, 'Perfect Adventurer', 'Finish a game with max health'),
  oops(6, 'Oops...', 'Consume the Volatile Elixir with full equipment'),
  highScore(7, 'High Score!', 'Reach 10.000 Score'),
  reducedToAtoms(8, 'Reduced To Atoms', 'Reduce a monster power to 0'),
  nakedButNotAfraid(
    9,
    'Naked But Not Afraid',
    'Finish the game without any accessory',
  );

  const Achievement(this.id, this.name, this.description);

  final int id;
  final String name;
  final String description;
}
