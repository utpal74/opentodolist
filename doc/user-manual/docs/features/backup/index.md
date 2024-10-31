# Backup

Loosing data sometimes happens easier than you might expect! To avoid the data
to be gone forever, it can help to regularly take backups of your data. In this
chapter, we'll discuss the means that OpenTodoList has built into it to aid in
this.


## Keeping Your Data Online

Generally, the most secure way to prevent your data to get lost is to keep it
_online_. OpenTodoList has some [sync mechanisms](../sync/index.md) built
into it which you can use to keep your data synchronized across several devices.
Even if you use some libraries only on one device, these mechanisms can help you
to keep an online copy of a library on a server - so you still have a copy of it
in case e.g. your device gets lost. If possible, take advantage of this feature.

!!! warning
    You might be tempted to stop reading here, but please go on. Setting up sync
    for your libraries is one part of the puzzle, but ideally, you don't rely
    on that mechanism only.

    Although we try to employ defensive programming where possible, it can
    also happen that e.g. something goes wrong during a sync operation and
    you loose data not only on your device but also the server (e.g. because
    some unintended deletions are _synced_ to the server). In such cases, having
    additional backups might allow you to restore otherwise lost items as a last
    resort.

!!! note
    Setting up sync for your libraries might - depending on the used backend
    service you use for the synchronization - enable additional features.
    For example, Nextcloud can be set up to keep also previous versions of
    individual files. This allows you to restore these previous versions via the
    server's user interface.

## Creating A Backup Of A Library

Backups in OpenTodoList are done _per library_. To create such a backup, run
the following steps:

First, navigate to the library that you want to backup. There, open the file
menu and use the option **Backup** to initiate a backup:

![The File Menu](./file-menu.png){: width=300}

Once the backup has been created, the app will open the backup folder. The
backup folder is a subfolder within the library itself (it is called `.backup`)
and holds one or more backups as zip files. The file name holds the
date and time when the backup has been created:

![Backup Folder](./backup-folder.png){: width=600}

!!! note
    On mobile devices, the created backup is opened directly. Use the device's
    share options to e.g. copy the file to a file app.

!!! note
    The folder might contain more than one backup. OpenTodoList keeps backups
    for a certain period of time before deleting them automatically.

!!! warning
    The zip files contain a 1:1 copy of the library's data on disk. Do not
    try to restore the data manually except you exactly know what you are doing!

    In particular, do not unzip the folder and add the same library a second
    time to the app - this will not work as expected!
