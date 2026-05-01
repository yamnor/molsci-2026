#import "@local/molsci-2026:0.1.0": *

#let m = meta(
  number: "1A01",
  title: (
    ja: [講演題目（日本語）],
    en: [Title in English],
  ),
  authors: (
    (ja: [発表 太郎], en: [Taro Happyo], affil: 1, presenter: true),
    (ja: [共著 花子], en: [Hanako Kyosho], affil: 1),
  ),
  affiliations: (
    (ja: [大学院理学研究科], en: [Graduate School of Science, Example University, Japan]),
    (ja: [別所属略称], en: [Other Institute, Japan]),
  ),
)

#show: manuscript.with(..m)

#abs[
  English abstract (about 150 words). Replace this paragraph with your summary.
]

#sec[序][
  分子科学討論会の講演要旨の本文をここに書きます。
]

#sec[方法][
  方法をここに書きます。
]

#sec[結果・考察][
  結果・考察をここに書きます。
]

#refs[
  [1] Author, A.; Author, B. _Journal Name_ *volume*, pages, year.
]
