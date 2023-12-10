#import "../lib/presentation-template.typ": *
#show: template.with(name: "Обзор GOLEM", time: 35, bad-projector: false, authors: "V")

#let amark = place(top+right, dy: -20pt, dx: 2em, line(length: 20%, stroke: orange + 10pt))

#let vmark = place(top+right, dy: -20pt, dx: 2em, line(length: 20%, stroke: purple + 10pt))

#show list: it => {
  show list.item: set list(marker: text(sym.arrow.curve, font: "New Computer Modern Math"))
  it
}

#slide[
== Глобально про алгоритм

=== Многокритериальная оптимизация
]

#slide[
  == Ближе к коду

- Package core contains the main classes and scripts.
- Package core.adapter is responsible for transformation between domain graphs and internal graph representation used by optimisers.
- Package core.dag contains classes and algorithms for representation and processing of graphs.
- Package core.optimisers contains graph optimisers and all related classes (like those representing fitness, individuals, populations, etc.), including optimization history.
- Package core.optimisers.genetic contains genetic (also called evolutionary) graph optimiser and operators (mutation, selection, and so on).
- Package core.utilities contains utilities and data structures used by other modules.
- Package serializers contains class Serializer with required facilities, and is responsible for serialization of project classes (graphs, optimization history, and everything related).
- Package visualisation contains classes that allow to visualise optimization history, graphs, and certain plots useful for analysis.
- Package examples includes several use-cases where you can start to discover how the framework works.

- All unit and integration tests are contained in the test directory.
The sources of the documentation are in the docs directory.

]

#slide[
  == Issues


]

#slide[
  === Направления развития

  ==== NOTEARS

  ==== Метаэволюция

  

  ==== Коэволюция

  ==== Поддержка разнообразия

  ==== Expressive encodings


]