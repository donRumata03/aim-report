#import "../lib/presentation-template.typ": *
#show: template.with(name: "Обзор GOLEM", time: 35, bad-projector: false, authors: "V")

#show list: it => {
  show list.item: set list(marker: text(sym.arrow.curve, font: "New Computer Modern Math"))
  it
}

#slide[
  Дисклеймер: презентация больше адаптирована для рассказа с периодическим переходом на демонстрацию экрана со статьями, issues или кодом, но на свой страх и риск можно и попробовать её читать без докладчика.
]

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
== Возможности FEDOT

#image("../res/fedot-capabilities.png")
]

#slide[
== Глобально про алгоритм

#blockquote[Структура — сложный гиперпараметр, так у самого задания структуры нет фиксированной структуры…]

Использует эволюцию для оптимизации над графами, в том числе — многокритериальной. Предоставляет многие стаднартные операторы, есть интерфей для добавления пользовательских.
]

#slide[
  = Операторы

  Глобально — то, что приоткрывает нам чёрноящиковость представления генома и преобразует одни геномы в другие.

  Эволюция — последовательное применение этих операторов.

  Ожидается их «семантичность»: например, то, что мы можем получать небольшие изменения структуры с точки зрения задачи → это отражается и на значениях фитнесс функции.

  Пример несемантичности: если кодировать вещественнозначные решения битами, получится плохо.
]

#slide[
  == Мутации
  Мутации и кроссовер учитывают `GraphGenerationRequirements`, а также `GraphVerifier`.

  Мутации, семантические для графов:
    - Заменить аттрибут каждой ноды с заданной вероятность на то, что сгенерирует `NodeFactory` и так, как посоветует `ChangeAdvisor` (например, в химии некоторые связи невозможны)
    - Добавление ребра между случайными нодами
    - Вставка случайной ноды в разрыв ребра
    - Заменить/выбросить ноду
    - Заменить поддерево ноды на случайное
    - …пользовательские, особенно семантические
]

#slide[
  == Кроссовер
    - Замена случайных поддеревьев
    - Нахождение структурно эквивалентных подграфов и замена случайных нод или поддеревьев в них
    - Смена родителями с аналогичной нодой в другом графе
    - … пользовательские
]

#slide[
  == Селекция
  1. Tournament(fraction): каждый раз из группы размера $≈"population_size" * "fraction"$ выбирается лучший в итоговую популяцию и убирается из кандидатов.
  2. SPEA-2

    Strength — количество особей, которые доминирует заданная:
    $ S(bold(i)) = |{bold(j) | bold(j) in P_t + overline(P_t) and bold(i) gt.curly bold(j)}| $
    Тогда назначаем raw fitness-ом сумму strengths всех, кого особь доминирует (то есть особо выгодно доминировать крутых):
    $
    R(bold(i)) = sum_(bold(j) in P_t + overline(P_t), bold(i) gt.curly bold(j)) S(bold(j)) $
    
    Но ещё хотим учитывать разнообразие. Про пространство оптимизации в общем случае ничего не знаем, поэтому считаем разнообразие в пространстве objective functions: $
    R(i) = 1/(sigma_bold(i)^k + 2)
    $, где $sigma_bold(i)^k$ — расстояние k-го ближайшего среди популяции + архива, а $k$ выбирают $sqrt(N + overline(N))$

    - Селекция новой популяции: производим селекцию турниром по F с заменой (участников турнира убираем из кандидатов)
    - Селекция архива: выбираем недоминированных, но если не соответствует целевому размеру:
      - Слишком большой: truncat-им по фитнессу (раз недоминированные, эквивалентно, по плотности): на каждому шагу убираем лексикографически меньшего по вектору расстояний до $k$-го ближайшего:
      #image("../res/spea2-truncation.png")
      - Слишком маленький: добавляем оставшихся сортировкой по фитнессу.
]

#slide[
  == «Регуляризация»
  
  Тоже пытается минимизировать сложность моделей (по умолчанию — отключен): рассматривает все валидные и уникальные поддеревья и выбирает среди родителей и детей лучших (эти поддеревья проще и хорошо, если они окажутся не хуже родителей)
]
#slide[
  == Inheritance(Genetic scheme)

    - `generational`: новая популяция занимает место старой $(mu, lambda), mu = lambda$
    - `steady-state`: каждый раз добавляем по одному — $(µ + 1)$
    - `parameter-free`: $(mu + x)$ — $x$ растёт, если давно не было улучшений ($=>$ нужно увеличивать exploration)
]

#slide[
  == Регулятор репродукции ($"Population" -> "Population"$)
  
  Есть min_size, max_size; некоторые операторы вероятностны и не всегда генерируют подходящие под `GraphRequirements` графы: он пробует применять операторы несколько раз + изучает, сколько в среднем процентов успешны.
]

#slide[
  == Elitism
  
  Поддерживать HallOfFame, во внеочередном подярке добавлять individual-ов оттуда.
]

#slide[
  = Откуда торчат уши FEDOT
  == Тюнинг

  По увеличению эффекитвности, но уменьшению качества:
  - Одновременно все ноды
  - По очереди с пересчётом
  - По очереди без пересчёта
]

#slide[
  == Sensitivity analysis 

  #side-by-side(image("../res/sensitivity-analysis.png", height: 90%), align(horizon)[
    - Для экспертной оценки конечного продукта
    - Назначают скоры полезности, пробуя разные локальные изменения
  ])
]

#slide[
  = Проект под кодовым названием #strike[GAMLET] \<anonymized\>

  Глобально: втыкаем в разные места эволюции ML модели:
  - Где мы точно не знаем, какой вариант лучше и поэтому выбираем случайный
  - Где вычисление занимает очень много времени, и можно настроить аппроксиматор для его ускорения.

]

#slide[
  == Общая схема
  #image("../res/gamlet-scheme.png", height: 90%)
]

#slide[
  == Расшаренный эмбеддинг для трёх задач:

  #image("../res/gnn-embedding.png", height: 90%)
]

#slide[
  == Адаптивность

  `OperatorAgent`: интерфейс подборщика мутаций, по умолчанию — `RandomAgent`, но может обучаться. Получается задача multi-armed bandit или contextual MAB.

  В качестве контекста используются фичи графов, пытаемся рекомендовать мутации для конкретного графa, обучение происходит «под конкретную задачу» в прошлых прогонах + немного на лету:
    - feather_graph ← FEATHER embedding
    - nodes_num
    - labeled_edges
    - operations_quantity
    - adjacency_matrix
    - none_encoding
]

#slide[
  === #link("https://arxiv.org/abs/2012.01780")[Shallow exploration & deep representation]

  Решают contextual MAB через нейросеть + LinUCB (сйечас пробуют $epsilon$-greedy, так как он не сходится полностью, в отличие от UCB, а ведь распределение наград может меняться).

  Доказывают, что это обеспечивает $tilde(O)(sqrt(T))$ regret.

  см. статью.

  Кроме того, перед этим трансформируют в fitness improvement в credit согласно этой статье: #link("https://ieeexplore.ieee.org/document/6410018")[Li, 2014].
]

#slide[
  == Изначальные рекомендации pipleline-ов

  Выдаёт nearest neighboors в пространстве embedding-а, либо использует генеративную GNN.
]

#slide[
  == Surrogate model

  Pilpeline (без учёта гиперпараметров) embedd-ится (общая часть с адаптивностью) с помощью GNN + attention (была картинка), датасет описывается метапризнаками (перечислены в статье), нужно предсказать, насколько хорошо будет себя вести модель. На практике — лучше получается формулировка с ранжированием (см. статью).
]

#slide[
  == Как это всё обучать

  Есть метахранилище, где много историй оптимизации, куча evaluation-ов разных pipleline-ов на разных dataset-ах.

  С големом не поставляется, с FEDOT-ом — да.
]


#slide[
  == Перспективы

  Выбираются только типы мутаций, а ведь хочется ещё и их параметры (например, вероятности мутаций) — их как раз берём от балды…

  Гиперпараметры эволюции всё ещё нужно указывать ручками, а ведь их можно динамически подстраивать.

  Кроме того, хочется иметь более широкий контекст в виде эволюционной ситуации для бандита.

  Но какой-то inductive bias всё же должен быть.

  С другой стороны, есть llm-guided evolution, которая ещё и обладает априорным знанием о пайплайнах и датасетах.
]

#slide[
  = Ближе к коду

Язык: Python. Библиотеки:
- joblib + multiprocessing
- torch + mabwiser + karateclub для контекстуального бандита на GNN

  _перемещаемся на демонстрацию экрана с IDE_

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
== Adapter Subsystem (преобразование между представлениями графа)

#side-by-side[
#image("../res/adapter.png")
][
- Обычно предметная область имеет своё представление графа (например, из внешней либы): химия, BAMT, FEDOT
- Fitness, операторы
- `@register_native`, e.g. `GraphVerifier`
- Поставляется адаптер к NetworkX
- Сейчас используется внутреннее представление в виде рукописного графа «на ссылках» в python
]
]

#slide[
  == Сериализация
  - Pickle (e.g. бандиты)
  - json (в т.ч. pipleline-ы в FEDOT)
]

#slide[
  == Issues

  _перемещаемся на демонстрацию экрана_
]

#slide[
  = Пример использования: BAMT
  #image("../res/bamt-pipeline.png")
]

#slide[
  Есть вещественные и непрерывные переменные, от этого зависит процесс обучения. Описано в статье про BAMT: 
  #link("https://www.mdpi.com/2227-7390/11/2/343")[Advanced Approach for Distributions Parameters Learning in Bayesian Networks with Gaussian Mixture Models and Discriminative Models (2023)]

  Тюнятся в порядке topsort-а DAG-а, для зависимости от дискретной используется CPT, для зависимости непрерывных — линейные, гауссовы зависимости, Gaussian mixture regression.
]

#slide[
  = Направления развития

  Источники:
  - Issues
  - Разговоры с коллективом лаборатории
  - Мои рассуждения
  - Рекомендации из review к paper по GOLEM-у.
]

#slide[
  == Expressive encodings
  - Прямо как в жизни — в геноме кодируется распределение, не просто какой-то конкретный фенотип, а больше информации. Заодно — и, частично, то, как проходит эволюция. Например, генотип мужчины содержит информацию о том, каким бы он мог быть, если бы был женщиной — очень много избыточности, и в этом есть смысл.

  - Приближает к положению дел в ML, где используют достаточно абстрактные модели вместо экспертного знания.


]

#slide[
  === Определение выразительной кодировки

  #blockquote[Прообразы любого набора фенотипов, пропущенные через простой оператор, могут симулировать любое веростностное распределение с любой точностью, начиная с некоторого размера генома.]

  #image("../res/expressive-encoding-definition.png")
]

#slide[
  === Пример: miracle jump
  
  Стартуем с кучи нулей, хотим знать, можно ли с неисчезающей вероятностью кроссовером получить 
  #image("../res/miracle-jump.png")
]

#slide[
  === Примеры expressive encodings — теоремы про экспрессивность
  Complexity — размер генома, требуемый для фиксированного уровня аппроксимации.
  #image("../res/gp-expressive.png", width: 70%)
  #image("../res/nn-expressive.png", width: 70%)
  #image("../res/universal-approx.png", width: 50%)
  #image("../res/universal→expressive.png", width: 70%)
]

#slide[
  === Преимущества выразительных кодировок
  Потом на разных примерах показывают более хорошую асмиптотику expressive encoding-ов по сравнению с direct; про скорость адаптации к меняющейся функции ошибки.

  (см. статью)
]

#slide[
  === Выразительные кодировки для графов

  В нашем случае кодировкой может быть
  - графивые грамматики
  - клеточное кодирование
  - GNN
  _с тривиальными мутациями/кроссоверами_.

  #image("../res/cellular.png")
]

#slide[
  == NOTEARS

  #image("../res/notears-theorem.png")

  → сводим к задаче непрерывной оптимизации; целевая функция и ограничения — дифференцируемы.
  Решаем с помощью метода расширенной Лагранжианы.

  Ограничения:
  - Целевая функция должна естественно (дифференцируемо, поменьше константа Липшица, легко вычислима) продолжаться на вещественные веса
  - Как задать на пространстве, содержащем категориальные переменные?

  Как может совмещаться с GOLEM-ом? Идея: оператор локального улучшения.
]

#slide[
  == Метаэволюция

  Пытаемся адаптировать гиперпараметры эволюции (частоту мутаций, размер популяции и т.д.). Похоже на предложение к GAMLET, но теперь эти параметры именно эволюционируют.

  см. обзорную статью: Parameter Control in Evolutionary Algorithms: Trends and Challenges
]


#slide[
  == Коэволюция
  см. `proposal.pdf`
]

#slide[
  == Поддержка разнообразия
  см. `proposal.pdf`
]
