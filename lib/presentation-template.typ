#import "@preview/polylux:0.3.1": *
#import "pdfpc.typ"
#import themes.simple: title-slide, logic
#import "presentation-utilities.typ": timeblock, codeblock, superblock, set-code, set-code-for-bad-projector
#import "todos.typ": *
#import "generic-utils.typ": *


#let simple-theme(
  aspect-ratio: "16-9",
  background: white,
  foreground: black,
  body
) = {
  set page(
    paper: "presentation-" + aspect-ratio,
    margin: 1em,
    header: none,
    footer: none,
    fill: background,
  )
  set text(fill: foreground, size: 25pt)
  show footnote.entry: set text(size: .6em)
  // show heading.where(level: 2): set block(below: 2em)
  // set outline(target: heading.where(level: 1), title: none, fill: none)
  //show outline.entry: it => it.body
  // show outline: it => block(inset: (x: 1em), it)
  show emph: set text(fill: red.darken(20%))
  show raw: set text(font: "Fira Code")


  body
}

#let slide(body) = {

  body = if "heading" in repr(body){
    show heading: it => it + v(1fr)
    body
  }
  else {
    v(1fr) + body
  }

  let deco-format(it) = text(size: .6em, fill: gray, it)
  set page(
    footer: deco-format({
      locate(loc => {
        let sections = query(heading.where(level: 1, outlined: true).before(loc), loc)
        
        if sections == () [] else {
          set text(size: 2em)
          deco-format(sections.last().body)
        }
        h(1fr);
        logic.logical-slide.display() + [/] + str(logic.logical-slide.final(loc).at(0))
      }); 
      
    }),
    footer-descent: -0.1em,
    header-ascent: 1em,
  )
  logic.polylux-slide(body + v(1fr))
}

#let authors_d = ("V": "Владимир Латыпов", "I": "Илья Шпильков", "A": "Андрей Ситников")
#let comm(body) = text(gray, body)

#let template(body, name: "", authors: "AIV", time: 75, bad-projector: true) = {
  set text(lang: "ru")
  show link: set text(blue)

  show: simple-theme

  
  set raw(lang: "rs")
  show raw.where(block: false): box.with(fill: gray.lighten(90%), outset: (y: 5pt, x: 1pt), radius: 5pt)
  show raw.where(block: true, lang: "rs"): codeblock
  show raw.where(block: true, lang: "cpp"): codeblock
  show raw.where(lang: "error"): it => codeblock(nums: false, raw(it.text, lang: "rs"))

  show: set-code-for-bad-projector
  let comm(body) = text(gray.darken(50%), body)


  pdfpc.config(duration-minutes: time, last-minutes: 10)
  
  title-slide[
    #heading(level: 1, name)
    
    #v(2em)

    #for a in authors {
      authors_d.at(a)
      h(1em)
    }

    #datetime.today().display("[day]-[month]-[year]")

    #place(bottom+right, comm[NSS Lab ITMO])
    
  ]

  body
}

#let png-ferris = ("point", "laptop")
#let ferris(size: 40%, type: "point") = {
  let ext = if type in png-ferris {".png" } else {".svg"};
  
  box(image("../res/ferris-" + type + ext, height: size), baseline: 50%, inset: 1em)
}

#let notice(body, head: "", size: 0.5, fill: red.lighten(90%), inset: 0.2, padding: 1, type: "point") = align(center, block(
  stroke: red,
  fill: fill,
  radius: size * 1em,
  width: 100%,
  inset: size * inset * 1em,
  grid(columns: 2,
    ferris(size: size * 35%, type: type),
    pad(rest: size * padding * 1em, {
      set align(center + horizon)
      strong(head)
      " "
      body
      }
    )
  )
))

#let _s_align = align; 

//
#let question(ask: "", size: 1.0, align: right, dx: 0pt, dy: 0pt) = place(align,
  dx: dx,
  dy: dy,
  grid(
    _s_align(right, ferris(size: 25%*size, type: "question")),
    text(red)[#ask])
)

#let panics(ask: "", size: 1.0, align: right, dx: 0pt, dy: 0pt) = place(align,
  dx: dx,
  dy: dy,
  grid(
    _s_align(right, ferris(size: 25%*size, type: "panic")),
    text(red)[#ask])
)

#let livecode(size: 1.3, align: right, dx: 0pt, dy: 0pt) = place(align, dx: dx, dy: dy, ferris(size: 25%*size, type: "laptop"))

