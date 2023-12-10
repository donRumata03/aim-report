#import "@preview/big-todo:0.2.0": *

// Small todo
#let stodo = todo.with(inline: true)
#let todo = it => pad(y: 2em, (todo.with(gap: 0.2cm))[#it])