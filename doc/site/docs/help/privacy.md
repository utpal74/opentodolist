# Privacy And Data Ownership

OpenTodoList is built around a simple idea: your todo lists, notes, images, and
recipes should stay under your control.

The app does not run its own central service for your libraries. Instead, each
library is stored as files and folders. You decide whether that library stays on
one device or is synchronized through a service you configure.

## What Data Can Be In A Library?

A library can contain todo lists, todos, tasks, notes, note pages, images,
recipes, and attachments. The titles, descriptions, notes, photos, and other
files you add may contain personal information about you or others.

Treat a library as you would treat any other folder with personal documents.

## Local Libraries

If you create a local library, OpenTodoList stores it on the current device. The
app does not copy that library to a server.

Depending on your operating system and backup setup, other tools may still back
up or sync the folder. That is outside OpenTodoList itself, so check your device
or cloud backup settings if this matters for your use case.

## Synchronized Libraries

If you enable synchronization, OpenTodoList transfers the library data to the
service you configure. Supported options include Nextcloud, ownCloud, generic
WebDAV servers, Dropbox, and local libraries synchronized by external tools.

OpenTodoList does not control those services. They may be hosted by you, by your
organization, or by a third party. If privacy is especially important, a
self-hosted or otherwise trusted storage service gives you the most control.

## Accounts And Credentials

Some sync backends require an account. Depending on the backend, you may enter a
username and password, use an app password, or authenticate through the provider.

Use HTTPS whenever possible. If a WebDAV server is only reachable through plain
HTTP, data and credentials can be transmitted without transport encryption.
OpenTodoList does not prevent this, but it is not recommended for normal use.

## Practical Advice

- Use local libraries for data that should stay on one device.
- Use a sync provider you trust when you need multiple devices.
- Prefer HTTPS connections.
- Keep your server, storage account, and devices up to date.
- Make backups for libraries you cannot afford to lose.

For more about storage and sync choices, see the [Sync](../sync/index.md) guide.
