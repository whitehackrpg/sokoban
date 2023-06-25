# sokoban
A Sokoban implementation.

```
(ql:quickload :sokoban)
(in-package :sokoban)
(sokoban "<path to somefile.txt>")
```

Put your game in a simple .txt file, using # for walls, . for floor, B for crates and _ for goal tiles (see soko.txt). The program returns the number of moves.

Move with h/j/k/l, push the crates ('B') onto the goal tiles ('_') in as few moves as you can.
