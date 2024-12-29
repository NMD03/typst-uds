#import "template.typ" : *

#show: thesis.with(
  title: "Typst Template for UDS",
  author: "Your name",
  type: "Master Thesis",
  student_id: "XXXXXXXXXXX",
  date: datetime(
    year: 1984,
    month: 10,
    day: 10,
  ),
  time_period: "01.01.2023 - 00.00.2024",
  confidentiality_clause: false,
  language: "en",
  supervisor: "Someone",
  first_referee: "Someone else",
  second_referee: "Someone else",
  signature: "hide", // TODO
)


// Requirements:
//

= Introduction

#include "./chapters/01-Introduction.typ"

#pagebreak()

= Technical Background

== Spell checking

You can use #link("https://github.com/crate-ci/typos")[Typos],
but I am too lazy to explain.

= Summary and Conclusion

#lorem(250)
