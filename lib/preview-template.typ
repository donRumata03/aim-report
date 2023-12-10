#set page(paper: "presentation-16-9")
#import "@preview/cetz:0.1.2": *

// #let someText = lorem(30)

#let previewTemplate(body, index: none, PTHSColor: fuchsia) = {
layout(pageSize => [
  #grid(columns: (30%, 70%))[
      #set align(center + horizon)
    
    #box(stroke: none, 
      fill: none,// rgb("#4f3a3a"), 
      width: pageSize.width / 2 * 1, height: pageSize.height, canvas({ // WHY IS THAN NOT THE WHOLE PAGE H@LF?!?!
        import draw: *
    
        // content((0, 0), image(height: 451pt, "res/PTHS.svg"), anchor: "center", name: "i")
        let tripleInt(pos, rules: it => it) = content(pos, [
          #show math.equation: set text(194pt)
          #show: rules

          // $ integral.triple $
          $ integral $
        ], name: "i")
        tripleInt((0, 0))
        content(/*"i.center"*/(0.8, 0), image(height: 220pt, "../res/ferris-point.png"), anchor: "center", name: "i")
        let low-opacity = it => [#show math.equation: set text(fill: rgb(0%, 0%, 0%, 50%)); #it]
        // tripleInt(rules: low-opacity, (1.5, 0))
        // tripleInt(rules: low-opacity, (-1., 0))
        
        // content((-5, 0), [#text(size: 158pt, fill: PTHSColor, "Ф")], anchor: "center", name: "i")
        // content((5, 0), [#text(size: 158pt, fill: PTHSColor, "Ш")], anchor: "center", name: "i")
    }))
  ][
      #set align(center + horizon)
      #show heading: it => [
        #set align(center)
        #set text(75pt / it.level, weight: "bold", /* line-spacing: 2pt */) // Former 140pt
        #block(smallcaps(it.body))
      ]
      #set text(size: 3em)
  
    = Rust
    #v(-1em)
    == Лекция #str(index)
    #v(-0.5em)

    #body
   
  ]])
}
// #let thing = style(styles => [
//   #let img = image("res/PTHS.svg")
//   #locate(loc => [
//     // #measure(img, styles)

//     // #loc.position()

//     #place(
//       top+start, 
//       // float: true,
//       dx: loc.position().x + measure(img, styles).width / 2, 
//       dy: loc.position().y + measure(img, styles).height / 2
//     )[1]
// ])
//   #img
  
// ])
// #thing
// #box(stroke: 2pt + red, canvas({
  // import draw: *

  // content((0,0), image("res/PTHS.svg"), anchor: "top-left", name: "integral")

  // set-style(radius: 0.1)
  // for k in ("top-left", "top", "top-right", "left", "center", "right",
  //           "bottom-left", "bottom", "bottom-right") {
  //     fill(blue); circle("integral." + k)
  // }

  // fill(red); 
  // circle(("integral.top-left", 0.75, "integral.top-right"))
// }))