# Welcome

This is the user manual for OpenTodoList - a free and Open Source todo and
note keeping app that runs on a variety of platforms and hence, allows to
keep your precise information synchronized across all of your devices.

!!! note

    This documentation is heavily *work in progress*. OpenTodoList is
    already quite old (in terms of software) and provides a relatively
    big set of features. We will keep extending this documentation over
    time, documenting new features *on the fly* and one by one also add
    documentation for existing ones.

## About

OpenTodoList is a cross platform tool which allows you to maintain the following
*items*:

- **Todo Lists** which in turn contain **Todos** which finally contain
  **Tasks**.
- **Notes**, which consist of text and can contain additional **Pages**.
- **Images**, which combine an image file with some text.

These items are organized in **Libraries** - think of them as a kind of folder
which can be configured for synchronization (or not!) and also be shared with
other people.

![Libraries are used to organize items](assets/screenshots/iPhone 15 Pro Max/library.png){: width=200}
![Todo lists group several tasks together](assets/screenshots/iPhone 15 Pro Max/todolist.png){: width=200}
![Todos represent a single item of work](assets/screenshots/iPhone 15 Pro Max/todo.png){: width=200}
![Notes are collections of text](assets/screenshots/iPhone 15 Pro Max/note.png){: width=200}
![Images prominently render a picture](assets/screenshots/iPhone 15 Pro Max/image.png){: width=200}

See the [Features](#features) section for a brief overview of all supported
features that the app provides.

OpenTodoList originally dates back all the way to the year 2013 - in July that
year, a first announcement was made about the first version of the app. Frankly,
the app started as a playground to learn about the (back then) pretty new
QML and Quick stack within the [Qt framework](https://qt.io) - the cross
platform toolkit that backs the app and allows easily building it for a wide
range of operating systems and devices.

![Initial GUI of OpenTodoList - Todo List](assets/initial-01.png){: width=300}
![Initial GUI of OpenTodoList - Todo](assets/initial-02.png){: width=300}
![Initial GUI of OpenTodoList - Date Picker](assets/initial-03.png){: width=300}

Over time, though, the app evolved quite a bit, incorporating ideas from other
applications. Notably:

- Wunderlist: This app was - for a long time - the main inspiration for
  OpenTodoList. Wunderlist was a *pure* todo list app, concentrating on
  managing work.
- Google Keep: This app had an interesting approach, allowing other types of
  items next to your todo lists.

Of course, it didn't stop there: Due to suggestions of users, new features
where added that eventually made OpenTodoList a quite unique application.

## Installation

OpenTodoList is available on various operating systems and device types - thanks
to the wonderful [Qt](https://qt.io) framework! Qt allows us to maintain a
single code base for the app and simply build and deploy for a lot
of targets with relatively low effort.

For this reason, we are able to provide you with pre-built, ready to install
and use packages of the app. But: Even if your system is not directly
supported, this doesn't mean you cannot use the app. Both Qt and OpenTodoList
are Open Source, so you can try to compile the app yourself for your system.

Check out the [Installation](./installation/index.md) for details about
various options for getting the app.

## Features

Over the years, a lot of features have been added to the app. We cannot
describe all of them here in detail, so please refer to the
[Features](./features/index.md) section for details. The list of features
that the app implements includes (but is not limited) to the following:

### Data Model

- The app structures items in [Libraries](./features/data_model/library.md).
  These can contain the following types of items:
  - [Todo Lists](./features/data_model/todolist.md), which in turn contain
    [Todos](./features/data_model/todo.md). Todos can further be broken down
    into [Tasks](./features/data_model/task.md).
  - [Notes](./features/data_model/note.md), which are text containers and
    which can optionally include further [Pages](./features/data_model/page.md).
  - [Images](./features/data_model/image.md), which combine an image file with
    additional meta information like a title and notes.

### Sync

The app allows to synchronize libraries across your devices using the following
services:

- [NextCloud](./features/sync/nextcloud.md)
- [ownCloud](./features/sync/owncloud.md)
- [Generic WebDAV servers](./features/sync/webdav.md)
- [Dropbox](./features/sync/dropbox.md)

Besides, you can always add [local libraries](./features/sync/local_library.md),
which stay on the device you create them on.

## Further Reading

Over the years, we repeatedly received some questions on how the app works
and why some features cannot be implemented as some users wished while others
can. To shed some light on these aspects of the app, please feel encouraged to
continue reading in the [Basics](./basics/index.md) section.