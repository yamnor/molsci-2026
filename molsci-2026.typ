// 分子科学討論会 講演要旨用 Typst スタイル（FORM_Mol_Sci_Jpn に準拠）
//
// 用法:
//   #import "molsci-2026.typ" as ms
//   #let m = ms.meta(
//     number: "1A01",
//     title: (
//       ja: [講演題目・必要に応じて二行目],
//       en: [Second Line of Title if needed],
//     ),
//     authors: (
//       (ja: [吉田 都],     en: [Miyako Yoshida],   affil: 1, presenter: true),
//       (ja: [豊中 花子],   en: [Hanako Toyonaka],  affil: 2),
//       (ja: [矢上 太郎],   en: [Taro Yagami],      affil: 3),
//     ),
//     affiliations: (
//       (ja: [京大院理],   en: [Graduate School of Science, Kyoto University, Japan]),
//       (ja: [阪大院理],   en: [Graduate School of Science, Osaka University, Japan]),
//       (ja: [慶応院理工], en: [Faculty of Science and Technology, Keio University, Japan]),
//     ),
//   )
//   #show: ms.manuscript.with(..m)
//   #ms.abs[Abstract in English (ca. 150 words).]
//   #ms.sec[序][分子科学討論会の講演要旨は…]
//   #ms.refs[ [1] … \ [2] … ]
//   #ms.figs("assets/fig.png", caption: [Experimental Data.])

#let heading-fonts = (
  "YuGothic",
  "Hiragino Kaku Gothic ProN",
  "Noto Sans JP",
  "Helvetica Neue",
  "Arial",
)

#let mincho-fonts = (
  "YuMincho",
  "Hiragino Mincho ProN",
  "Noto Serif JP",
)

#let times-stack = ("Times New Roman", "Times")

// 括弧「【】」を明朝優先で描画し、欧文は Times にフォールバック（括弧の字形をそろえる）
#let bracket-label-fonts = (..heading-fonts, ..times-stack)

#let bracket-label(body) = {
  text(font: bracket-label-fonts, size: 10pt, weight: "bold")[#body]
}

#let meta(
  number: none,
  title: (ja: [], en: []),
  authors: (),
  affiliations: (),
) = (
  number: number,
  title: title,
  authors: authors,
  affiliations: affiliations,
)

// 上付き番号。複数所属は (1, 2) のような配列で渡せる。
#let _aff-mark(affil) = {
  let nums = if type(affil) == array { affil } else { (affil,) }
  super(nums.map(n => str(n)).join(","))
}

#let _author-mark(author, lang) = {
  let name = if lang == "ja" { author.ja } else { author.en }
  let presenter = author.at("presenter", default: false)
  let mark = _aff-mark(author.affil)
  if presenter [○#name#mark] else [#name#mark]
}

#let _format-authors(authors, lang) = {
  let sep = if lang == "ja" { [、] } else { [, ] }
  let parts = authors.map(a => _author-mark(a, lang))
  parts.join(sep)
}

// 和文の略所属（1 行）: 「¹京大院理，²阪大院理，³慶応院理工」
#let _format-affiliations-ja(affiliations) = {
  let parts = affiliations.enumerate().map(((i, a)) => {
    [#super(str(i + 1))#a.ja]
  })
  parts.join([，])
}

// 英文所属: 番号付きで縦積み（本文はイタリック、上付き番号は立体）
#let _format-affiliations-en(affiliations) = {
  if affiliations.len() == 0 { return [] }
  let lines = affiliations.enumerate().map(((i, a)) => {
    [#text(style: "normal")[#super(str(i + 1))]#h(0.3em)#a.en]
  })
  stack(dir: ttb, spacing: 0.5em, ..lines)
}

#let manuscript-header(
  number: none,
  title: (ja: [], en: []),
  authors: (),
  affiliations: (),
) = {
  if number != none {
    text(font: heading-fonts, size: 14pt, weight: "bold")[#number]
    v(1.4em)
  }

  align(center)[
    #block(spacing: 0em)[
      #set par(leading: 0.5em)
      #text(font: heading-fonts, size: 14pt, weight: "bold")[#title.ja]
    ]
    #v(1.3em)
    #text(font: mincho-fonts, size: 12pt)[#_format-affiliations-ja(affiliations)]
    #v(0.7em)
    #text(font: mincho-fonts, size: 12pt)[#_format-authors(authors, "ja")]
    #v(1.6em)
    #block(spacing: 0em)[
      #set par(leading: 0.5em)
      #text(font: times-stack, size: 14pt, weight: "bold")[#title.en]
    ]
    #v(1.3em)
    #text(font: times-stack, size: 12pt)[#_format-authors(authors, "en")]
  ]

  v(0.7em)
  align(center)[
    #set text(font: times-stack, size: 12pt, style: "italic")
    #set par(leading: 0.78em)
    #_format-affiliations-en(affiliations)
  ]
  v(1.1em)
}

#let manuscript(
  number: none,
  title: (ja: [], en: []),
  authors: (),
  affiliations: (),
  body,
) = [
  #set page(
    paper: "a4",
    margin: (top: 25mm, bottom: 25mm, left: 25mm, right: 25mm),
    numbering: none,
  )
  #set text(font: mincho-fonts, size: 10pt, lang: "ja")
  #set par(justify: true, first-line-indent: 1em, leading: 0.78em, spacing: 0.65em)
  #set figure(gap: 1.2em, supplement: [Fig.], numbering: "1")
  #show figure: set block(above: 1.2em, below: 1.2em)
  #set figure.caption(separator: [. ])
  #show figure: it => align(center, it)
  #show figure.caption: it => {
    set text(font: times-stack, size: 11pt)
    set par(leading: 0.72em)
    align(center)[
      #text(weight: "bold")[#it.supplement #context it.counter.display(it.numbering).]
      #h(0.3em)
      #it.body
    ]
  }

  #show strong: it => text(font: heading-fonts, weight: "bold", it)

  #manuscript-header(
    number: number,
    title: title,
    authors: authors,
    affiliations: affiliations,
  )

  #body
]

// 【Abstract】: 見出しと本文をインラインで続ける。Times 12 pt。
#let abs(body) = [
  #v(0.45em)
  #block(width: 100%, spacing: 0.65em)[
    #set text(font: times-stack, size: 12pt, lang: "en")
    #set par(justify: true, first-line-indent: 0em, leading: 0.6em, spacing: 0.55em)
    #bracket-label[【Abstract】]#h(0.5em)#body
  ]
]

#let sec(name, body) = [
  #v(0.85em)
  #set text(font: mincho-fonts, size: 10pt, lang: "ja")
  #set par(justify: true, first-line-indent: 0em, leading: 0.78em, spacing: 0.5em)
  #bracket-label[【#name】]#h(0.5em)#body
]

#let refs(body) = [
  #v(1em)
  #set par(first-line-indent: 0em)
  #bracket-label[【参考文献】]
  #parbreak()
  #set text(font: times-stack, size: 11pt)
  #set par(justify: false, first-line-indent: 0em, leading: 0.78em, spacing: 0.5em)
  #v(0.5em)
  #body
]

#let img(path, w: 100%, h: auto) = {
  if h == auto {
    image(path, width: w)
  } else {
    image(path, width: w, height: h, fit: "contain")
  }
}

#let figs(
  items,
  labels: none,
  caption: [],
  gutter: 2mm,
  h: auto,
  w: 100%,
) = {
  let paths = if type(items) == str { (items,) } else { items }
  if paths.len() == 0 {
    panic("figs: 少なくとも 1 枚の画像を指定してください")
  }
  let label-list = if labels == auto {
    if paths.len() == 1 {
      ()
    } else {
      if paths.len() > 26 {
        panic("figs: labels:auto は 26 枚まで対応")
      }
      let letters = (
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
      )
      paths.enumerate().map(((i, _)) => [ (#letters.at(i)) ])
    }
  } else if labels == none {
    ()
  } else if type(labels) == array {
    labels
  } else {
    (labels,)
  }
  if label-list.len() > 0 and label-list.len() != paths.len() {
    panic("figs: labels の数は画像枚数と一致させてください")
  }
  let blocks = paths.enumerate().map(((i, path)) => [
    #img(path, w: w, h: h)
    #if i < label-list.len() { align(center, label-list.at(i)) }
  ])
  figure(
    if paths.len() == 1 {
      blocks.first()
    } else {
      grid(columns: paths.len(), gutter: gutter, ..blocks)
    },
    caption: caption,
  )
}
