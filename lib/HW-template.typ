#import "presentation-utilities.typ": codeblock, set-code

#import "@preview/showybox:1.0.0": showybox
#import "todos.typ": *
#import "generic-utils.typ": *

#let point-counter = counter("points")

#let comment(body, width: 20%, color: green.lighten(90%), dy: 0em) = place(right, dy: dy -1em, dx: 25%, 
  {
    set text(size: 0.85em)

    showybox(align: right, width: width, frame: (body-color: color), body)
})


#let template(body, name: "", deadline: none, p: none, bonus-p: none) = {

  set raw(lang: "rs")
  set text(lang: "ru")

  show raw.where(block: false): box.with(fill: gray.lighten(80%), outset: (y: 0.2em), radius: 0.2em)

  let codeblock = codeblock.with(size: 1.2em)

  show raw.where(block: true, lang: "rs"): codeblock

  show raw.where(block: true, lang: "cpp"): codeblock
  show raw.where(lang: "error"): it => codeblock(nums: false, raw(it.text, lang: "rs"))

  show raw: set text(font: "Fira Code")
  show emph: set text(fill: red.darken(20%))
  
  show link: set text(blue)
  show link: underline
  show link: emph
 
  set heading(numbering: "1.1.")
  

  set page(margin: (right: 20%))

  
  align(center, text(size: 2em)[Домашнее задание])
  align(center, text(size: 1.6em, name))
  
  comment(width: 40%,
    color: none,)[
    
    #text(blue.darken(50%), size: 1.2em)[
      Всего баллов: #h(1fr) #if p == none {locate(loc => point-counter.final(loc).at(0))} else {p}
    ]

    #if bonus-p != none {
      text(red.darken(30%), size: 1.2em)[
        Бонусные баллы: #h(1fr) #bonus-p
      ]
    }
  ]
  

  v(2em)
  

  body 
}




#let points(n) = {
  point-counter.update(c => c + n)
  comment(text(fill: blue.darken(30%), size: 1.05em)[Баллы: #h(1fr)] + str(n))
}



#let notice(fill: red, body) = block(stroke: fill, fill: fill.lighten(90%), inset: 1em, body)