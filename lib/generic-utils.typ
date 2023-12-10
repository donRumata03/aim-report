
#let blockquote = it => rect(stroke: (left: 2.5pt + gray.lighten(50%)), inset: (left: 1em), fill: gray.lighten(93%), {
  set text(size: 0.92em)
  it
})


#let lnk(dest, body) = link(dest, emph(underline(text(body, fill: color.mix(rgb("#0000FF"), rgb("#600000").darken(30%)))))) // How to use nested set rules?

