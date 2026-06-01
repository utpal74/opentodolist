# Data Model

The term _data model_ might sound nerdy at first (unless you _are_ a nerd), but
after all, it just means: _What_ kinds of _items_ are we talking about?

The following diagram illustrates the items that we app uses internally:

``` mermaid
erDiagram
  Library ||--o{ TodoList : contains
  Library ||--o{ Note : contains
  Library ||--o{ Image : contains

  TodoList ||--o{ Todo : contains

  Todo ||--o{ Task : contains

  Note ||--o{ Page : contains
```

- A [Library](./libraries.md) is a container for a set of top level items. These
  are:
  - [Todo Lists](./todo-lists.md) - lists of todos which can be worked on.
    - Todos in turn can contain [Tasks](./tasks.md), which allow to further break
      down the necessary work.
  - [Notes](./notes.md) are simple text containers - at least you can use them
    like this.
    - However, it is possible to add additional [Pages](./pages.md) to a note,
      which effectively makes a note a _Note Book_.
  - [Images](./images.md) are items which combine an image file (a photo,
    diagram, ...) with other attributes like a title and description.

Some properties of the various types of items are shared among most of them -
for example, all items have a _title_, nearly all of them a _description_ or
_notes_. Other properties are specific to a single type of item, e.g.
todos and tasks have a _done_ property, while images have an image file
associated with them.
