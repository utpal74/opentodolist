# WebDAV

The generic WebDAV backend lets OpenTodoList synchronize libraries with storage
services that expose a WebDAV interface.

This is the most flexible built-in backend, but it also depends most on the
server implementation. WebDAV is a standard, but real-world servers sometimes
behave differently or support only parts of it.

## When To Use WebDAV

Use this backend when:

- your storage provider supports WebDAV,
- you run a WebDAV server yourself,
- or you want to use a service that is not covered by the dedicated Nextcloud or
  ownCloud backends.

## Before You Start

Check the WebDAV URL, username, and password or app password provided by your
service. Some providers require a special endpoint rather than the normal web
login URL.

Prefer HTTPS. OpenTodoList can connect to WebDAV over HTTP, but plain HTTP does
not encrypt traffic between the app and the server.

If a server does not work correctly, try to reproduce the issue with a small test
library and report the exact provider or server version.
