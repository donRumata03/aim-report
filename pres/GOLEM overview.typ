#import "../lib/presentation-template.typ": *
#show: template.with(name: "Обзор GOLEM", time: 35, bad-projector: false, authors: "V")

#show list: it => {
  show list.item: set list(marker: text(sym.arrow.curve, font: "New Computer Modern Math"))
  it
}

#slide[
  = История появления

  Изначально была библиотека `FEDOT` для AutoML, основана на pipleline-ах ≈произвольной структуры (dag), поиск происходит посредством эволюции.
  Но алгоритм графовой оптимизации оказался полезен и для кучи других задач, в т.ч. проектов лаборатории:
  - BAMT (Bayesian AutoML Tool)
  - NAS (Neural Architecture Search)
  - GEFEST (#[*G*]enerative Evolution For Encoded STructures)
  - пользовательские применения (коллаборация с химической лабораторией, например — btw полезный подход)
  Поэтому было решено выделить эту часть в отдельную библиотеку — GOLEM.
]

#slide[
== Глобально про алгоритм

Тюнинг

=== Многокритериальная оптимизация
]

#slide[
  = Операторы

  - Мутация
  - Кроссовер
    - `subtree` — выбрать 
  - Селекция
  - «Регуляризация»
]

#slide[
  == Ближе к коду

Язык: Python. Библиотеки:
- joblib + multiprocessing
- torch + karateclub для контекстуального бандита на GNN

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
]

#slide[
  ==== NOTEARS

  #image("../res/notears-theorem.png")

  → сводим к задаче непрерывной оптимизации; целевая функция и ограничения — дифференцируемы.
  Решаем с помощью метода расширенной Лагранжианы.

  Ограничения:
  - Целевая функция должна естественно (дифференцируемо, поменьше константа Липшица, легко вычислима) продолжаться на вещественные веса
  - Как задать на пространстве, содержащем категориальные переменные?

  ==== Метаэволюция

  

  ==== Коэволюция

  см. Признаки

  ==== Поддержка разнообразия

  ==== Expressive encodings


]