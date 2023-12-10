#import "@preview/codelst:1.0.0": sourcecode, code-frame
#import "@preview/polylux:0.3.1": only


#let codeblock(body, highlight: (), dark: false, nums: true, fill: none, size: 1em, width: 100%) = {
    if dark {set text(fill: orange)}

    let sourcecode = if not nums {
      sourcecode.with(numbering: none)
    } else {sourcecode}

    set text(size: size)
    
    sourcecode(frame:
      code-frame.with(
        fill: if dark {black.lighten(5%)} else {fill},
        stroke: none, inset: (x: 5pt, y: 10pt)),
        highlighted: highlight,
        highlight-color: if dark {black.lighten(20%)} else {green.lighten(70%)}, body)
}

#let timeblock-only(blocks, index: 0) = {
  if blocks.len() == 0 {
    return
  }
  only(index + 1, blocks.remove(0))
  timeblock-only(index: index + 1, blocks)
}

#let timeblock(time-light: (), body, dark: false) = [
  #let timeblocks = time-light.map(h => codeblock(body, highlight: h, dark: dark))
  #timeblock-only(timeblocks)
]

#let superblock(body) = [
  #todo[
    Заплатите 1М\$, чтобы убрать ожидание этой функции.
  ]
]

#let set-code(size: 1) = {
  it => {
    show raw: set text(size: size*1em)
    it
  }
}

#let set-code-for-bad-projector(body) = {
  set raw(theme: "../res/GitHub.tmTheme")
  show raw: set text(size: 1.1em)
  body
}