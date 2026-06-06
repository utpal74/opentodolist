# Nextcloud

Nextcloud is a good fit for OpenTodoList if you want to synchronize your
libraries while keeping control over where they are stored.

You can use a self-hosted Nextcloud server or a provider you trust. OpenTodoList
stores the library data in your Nextcloud files area and uses your account to
read and write the files needed for synchronization.

## When To Use Nextcloud

Use this backend when:

- you already have a Nextcloud account,
- you want the same library on multiple devices,
- you want server-side storage without tying OpenTodoList to a proprietary app
  service,
- or you want to host the storage yourself.

## Security Notes

Prefer a Nextcloud server reachable via HTTPS. If you run your own server, keep
it updated and use a valid TLS setup. OpenTodoList can only protect the data
inside the app; the server and connection security are part of the environment
you choose.

If synchronization fails, first verify that you can log into the server and that
the Files app is available for the account.
