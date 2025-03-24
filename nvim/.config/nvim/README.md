---
author: "OXY2DEV"
---


; Block quotes


> A regular block quote.
> It spans across multiple lines.
>
> It also contains an empty line.

>[!ABSTRACT]

>[!SUMMARY]

>[!TLDR]

>[!TODO]

>[!INFO]

>[!SUCCESS]

>[!CHECK]

>[!DONE]

>[!QUESTION]

>[!HELP]

>[!FAQ]

>[!FAILURE]

>[!FAIL]

>[!MISSING]

>[!DANGER]

>[!ERROR]

>[!BUG]

>[!EXAMPLE]

>[!QUOTE]

>[!CITE]

>[!HINT]

>[!ATTENTION]


>[!NOTE]

>[!TIP]

>[!IMPORTANT]

>[!WARNING]

>[!CAUTION]


>[!ABSTRACT]
>
> >[!SUCCESS] Custom title
> >
> > >[!QUESTION]
> > >
> > > >[!FAILURE] Custom title
> > > >


; Code block


```c Info string
printf("Hello world!")
```

```html A very long info string that will not fit here! And to be absolutely sure I will add a few more words.
<p>Hello world!</p>
```

```js
console.log("Hello world!");
```

```lua
vim.print("Hello world!");
```

```md
Hello *world!*
```

```py
print("Hello world!");
```

```ts
console.log("Hello world!");
```

```typst
Hello _world!_
```


; Headings


# Heading 1

## Heading 2

### Heading 3

#### Heading 4

##### Heading 5

###### Heading 6


Setext 1
========

Setext 2
--------


; Horizontal rules


---

; Reference definitions

[Test]: www.neovim.org

; List items


- Item 1
+ Item 2
* Item 3
    - Nest 1
    + Nest 2
    * Nest 3
        1. Nest 4
        2. Nest 5
    * [X] Nest 6
    + [-] Nest 7
    - [/] Nest 8


; Tables


| Normal | Left | Center | Right
|--------|:-----|:------:| --: |
| 1 | 2 | 3 | 4 |
| **Bold** | *italic* | ***Bold italic*** | `Inline code` |
| [Shortcut] | [Link](reddit.com) | ![Image](test.svg) | [[Internal]] |



; Block reference

[[#^Block]]
![[Some_file.md#^Block]]

; Checkboxes

- [X] Checked
- [ ] Unchecked
- [/] Incomplete
- [>] Forwarded
- [<] Scheduling
- [-] Cancelled

- [?] Question
- [!] Important
- [*] Star
- ["] Quote
- [l] Location
- [b] Bookmark
- [i] Information
- [S] Savings
- [I] Idea
- [p] Pros
- [c] Cons
- [f] Fire
- [k] Key
- [w] Win
- [u] Up
- [d] Down

- [u] Item 1
  + [d] Nest 1

; Emails

Mail to <somemail@gmail.com>.

; Embed files

An ![[Embed file.md]]

; Entities

&#8659; &Int; &alpha; &Beta; &gamma;

; Escaped characters

\& \= \\ \| \.

; Footnotes

Work in progress. [^1]

[^1]:Footnote

; Highlights

Some ==Special text==.

; Hyperlinks

[Neovim](www.neovim.org)
[Reddit][example]

[example]:www.reddit.com

; Images

![Neovim.png](nvim.png)
![Icon](markview.svg)

; Inline codes

A line of `text`.

; Internal links

This is an [[internal link]].
They also support [[internal link|aliases]].

; URI autolinks

<https://www.example.com>

