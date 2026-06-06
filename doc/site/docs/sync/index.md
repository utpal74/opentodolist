# Sync

OpenTodoList can keep libraries on a single device, or synchronize them so the
same todo lists, notes, images, and recipes are available on several devices.

Synchronization is always something you choose for a library. A local library
stays on the device where you created it. A synchronized library is stored as a
set of files and folders and copied through one of the supported backends.

## Supported Backends

- [Nextcloud](./nextcloud.md)
- [ownCloud](./owncloud.md)
- [Generic WebDAV servers](./webdav.md)
- [Dropbox](./dropbox.md)
- [Local libraries with external sync tools](./local-libraries.md)

## Which Option Should I Pick?

If you already run Nextcloud or ownCloud, start there. Both are good choices
when you want control over the server that stores your data.

If you use another storage provider with WebDAV support, try the generic WebDAV
backend. WebDAV implementations can differ in subtle ways, so if something does
not work as expected, check the provider settings and report reproducible
issues.

Dropbox is available if that is already your preferred storage provider.

If you want to use a sync tool outside OpenTodoList, create a local library and
sync the library folder with your tool of choice. This works because an
OpenTodoList library is a normal directory on disk.

## Privacy And Transport Security

OpenTodoList does not operate its own sync service for your libraries. When you
enable sync, your data is transferred to the service you configure.

Use HTTPS whenever possible. If you connect to a WebDAV server over plain HTTP,
data and credentials can travel without transport encryption. OpenTodoList does
not block this configuration, but it is rarely a good idea outside a trusted test
setup.

For more context, see [Privacy and Data Ownership](../help/privacy.md).
