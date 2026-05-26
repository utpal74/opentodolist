# OpenTodoList Website And Documentation Migration Notes

This document is an inventory for consolidating the current OpenTodoList
documentation and website content. It was prepared for
https://gitlab.com/rpdev/opentodolist/-/work_items/709.

## Sources Reviewed

- `README.md`
- `doc/build-instructions.md`
- `doc/user-manual`
- `opentodolist-website`

## Current State

### README

The top-level README is both a project introduction and a distribution hub. It
contains:

- Product positioning: todo lists, notes, privacy, local-first data, optional
  sync.
- Supported sync backends: Nextcloud, ownCloud, generic WebDAV, Dropbox, plus
  local libraries with external sync tools.
- Supported platforms and download links for Android, iOS, Linux, macOS, and
  Windows.
- Screenshots pulled from `doc/user-manual/docs/assets/screenshots`.
- Help, bug reporting, translation, supported OS, and build-instruction links.

Recommended future role: keep this as a concise repository landing page for
developers and contributors. Move longer user-facing installation, sync, and
feature explanations into the MkDocs manual/site.

### MkDocs User Manual

The MkDocs manual lives in `doc/user-manual` and uses MkDocs Material with
search, social cards, awesome-pages, and glightbox.

The current manual has 24 Markdown files under `doc/user-manual/docs`, but many
are placeholders:

- Substantial pages:
  - `index.md`
  - `basics/index.md`
  - `basics/data_model/index.md`
  - `basics/data_model/library.md`
  - `features/index.md`
  - `features/backup/index.md`
  - `installation/index.md`
  - `installation/linux.md`
- Stub or empty pages:
  - `installation/android.md`
  - `installation/ios.md`
  - `installation/macos.md`
  - `installation/source.md`
  - `installation/windows.md`
  - `basics/data_model/image.md`
  - `basics/data_model/note.md`
  - `basics/data_model/page.md`
  - `basics/data_model/task.md`
  - `basics/data_model/todo.md`
  - `basics/data_model/todolist.md`
  - `features/sync/dropbox.md`
  - `features/sync/index.md`
  - `features/sync/local_library.md`
  - `features/sync/nextcloud.md`
  - `features/sync/owncloud.md`
  - `features/sync/webdav.md`

Recommended future role: make this the canonical user-facing documentation and
website content source. The structure already matches the needed topics; the
next work should fill the stubs and add website/legal/support pages.

### Old Jekyll Website

It is a Jekyll site with:

- Base URL: `https://opentodolist.rpdev.net`
- Main menu:
  - `/`
  - `/about`
  - GitHub releases as Downloads
  - GitLab repository as Fork It
  - `/donate`
- 92 posts in `opentodolist-website/_posts`
- 88 media assets in `opentodolist-website/images`
- Generated public pages in `opentodolist-website/_site`

The website acts primarily as a landing page plus release/news archive. Its
content is useful, but it overlaps heavily with the README and MkDocs index.

## Duplicated Content

- Product description:
  - `README.md`
  - `doc/user-manual/docs/index.md`
  - `opentodolist-website/_includes/short_info.md`
  - `opentodolist-website/about.md`
- Data model overview:
  - `README.md`
  - `doc/user-manual/docs/index.md`
  - `doc/user-manual/docs/basics/data_model/index.md`
  - `opentodolist-website/about.md`
- Sync overview:
  - `README.md`
  - `doc/user-manual/docs/index.md`
  - `doc/user-manual/docs/features/sync/*.md` placeholders
  - `opentodolist-website/about.md`
  - `opentodolist-website/privacy_policy.md`
- Installation/download links:
  - `README.md`
  - `doc/user-manual/docs/installation/index.md` and platform stubs
  - Jekyll menu link to GitHub releases
  - Nearly every release post repeats platform download links.
- Contribution/support links:
  - `README.md`
  - `opentodolist-website/donate.md`
- Privacy explanation:
  - `README.md` and user manual cover local-first positioning.
  - `opentodolist-website/privacy_policy.md` contains the fuller legal/user
    policy text.

## Outdated Or Risky Content

- Jekyll `about.md` says the app supports desktop systems and Android, but does
  not mention iOS in the opening platform list.
- Jekyll `about.md` still uses older spelling and wording such as `NextCloud`
  instead of `Nextcloud`, and contains typos such as `confitential` and
  `improvde`.
- `privacy_policy.md` contains useful policy content, but has old wording and
  typos such as `mac OS`, `organized content`, and `concise` where `conscious`
  is likely intended.
- Several historical release posts contain outdated download targets or old
  project URLs such as `rpdev.net/wordpress/apps/opentodolist/`.
- Release posts before the current release line are useful history, but should
  not be treated as current user documentation.
- The MkDocs manual has many empty topic pages. This creates navigation that
  promises coverage the manual does not yet provide.
- `README.md` still links to Read the Docs via the badge. If MkDocs becomes the
  canonical website/manual, confirm whether Read the Docs remains the deployment
  target or replace the badge/link.
- The Jekyll site contains generated `_site` content and `_backup_posts` sample
  content. These should not be migrated as source documentation.

## Useful Pages To Migrate

High priority:

- `opentodolist-website/privacy_policy.md` to a canonical privacy page in
  MkDocs. This URL is likely linked from app stores and should be preserved.
- `opentodolist-website/about.md` into the MkDocs landing/about content, after
  deduplicating against `README.md` and `doc/user-manual/docs/index.md`.
- `opentodolist-website/donate.md` into a support/contribute page.
- Current README download links into platform-specific installation pages:
  - `installation/android.md`
  - `installation/ios.md`
  - `installation/linux.md`
  - `installation/macos.md`
  - `installation/windows.md`
- Current README and website sync overview into:
  - `features/sync/index.md`
  - `features/sync/nextcloud.md`
  - `features/sync/owncloud.md`
  - `features/sync/webdav.md`
  - `features/sync/dropbox.md`
  - `features/sync/local_library.md`

Medium priority:

- Release posts from recent major versions, especially ones that describe still
  current user-facing features:
  - v3.51 recipes
  - v3.49 backup and configurable spot color
  - v3.48 color scheme
  - v3.47 toolbar, deep links, multi-window, and all-done behavior
  - v3.45 recurrence editor, recurring sub-tasks, accidental completion
    prevention, and auto-close
  - v3.41 library colors, global schedule view, recurrence end date, note
    excerpts
  - v3.39 completed item counters and sorting completed items at the end
  - v3.35 recurrence improvements
  - v3.34 quick notes
  - v3.31 settings
  - v3.27 background service/sidebar behavior
  - v3.26 Nextcloud login flow
  - v3.25 Markdown text styling
  - v3.23 recurrence patterns
  - v3.21 pull-to-sync
  - v3.19 accounts
  - v3.14 todo list page
  - v3.13 schedule view
  - v3.12 syntax highlighting
  - v3.5 due dates and schedule view
  - v2.5 tags

Low priority:

- Historical posts from 2013-2018 as a news archive only.
- Generated Jekyll archive/tag/category/search pages.
- `_backup_posts` sample content.

## Assets And Media

The old website has 88 files under `opentodolist-website/images`:

- 56 PNG files
- 16 GIF files
- 9 MP4 files
- 4 WebM files
- 3 JPG files

Important reusable assets:

- Branding and static site assets:
  - `images/logo.png`
  - `images/avatar.jpg`
  - `images/feature.jpg`
  - `images/gplv3-127x51.png`
  - apple touch icons and favicons
- Current/recent feature media:
  - `images/v3.51/recipes.png`
  - `images/v3.49/simple-backup.png`
  - `images/v3.49/custom-spot-color.mp4`
  - `images/v3.48/*.png`
  - `images/v3.47/*.mp4`
  - `images/v3.45/*.mp4`
  - `images/v3.41/*.png`
  - `images/v3.39/*.png` and `*.webm`
  - `images/v3.35/item-recurrence.gif`
  - `images/v3.34/quick-notes.png`
  - `images/v3.31/revamped-settings.webm`
  - `images/v3.26/nextcloud-login.gif`
  - `images/v3.25/text-styling.gif`
  - `images/v3.21/OpenTodoList-PullToSync.gif`
  - `images/v3.19/accounts.gif`
  - `images/v3.14/todolists.gif`
  - `images/v3.13/schedule-view.png`
  - `images/v3.12/syntax-highlighting.gif`
  - `images/v3.5/*.png`

Recommended migration approach:

- Copy only assets referenced by migrated pages into
  `doc/user-manual/docs/assets`.
- Keep historical release-post assets with the release archive if the archive is
  preserved.
- Avoid importing the full `images` directory into MkDocs unless the release
  archive is migrated wholesale.

## Public URLs To Preserve Or Redirect

Canonical existing website URL:

- `https://opentodolist.rpdev.net`

Top-level pages that should be preserved or redirected:

- `/`
- `/about/`
- `/donate/`
- `/privacy_policy/`
- `/posts/`
- `/tags/`
- `/categories/`
- `/search/`
- `/404/`
- `/feed.xml`

Release/news URLs should be preserved as an archive or redirected to a new
release/news section. The generated Jekyll site exposes post URLs directly under
the root, for example:

- `/opentodolist-3-51-1-has-been-released/`
- `/opentodolist-3-51-0-has-been-released/`
- `/opentodolist-3-50-1-has-been-released/`
- `/opentodolist-3-50-0-has-been-released/`
- `/opentodolist-3-49-0-has-been-released/`
- `/opentodolist-3-48-0-has-been-released/`
- `/opentodolist-3-47-0-has-been-released/`
- `/opentodolist-3-46-1-has-been-released/`
- `/opentodolist-3-46-0-has-been-released/`
- `/opentodolist-3-45-2-has-been-released/`
- `/opentodolist-3-45-1-has-been-released/`
- `/opentodolist-3-45-0-has-been-released/`

The full generated list can be recreated from the checked-out website with:

```sh
find opentodolist-website/_site -maxdepth 2 -type f -name index.html \
  | sed 's#opentodolist-website/_site##; s#/index.html#/#' \
  | sort
```

Other URLs to preserve because external platforms may link to them:

- Store links from the README and release posts:
  - Google Play: `https://play.google.com/store/apps/details?id=net.rpdev.opentodolist`
  - App Store: `https://apps.apple.com/.../opentodolist/id1490013766`
  - GitHub releases: `https://github.com/mhoeher/opentodolist/releases`
  - Snapcraft: `https://snapcraft.io/opentodolist`
  - Flathub: `https://flathub.org/apps/details/net.rpdev.OpenTodoList`
  - AUR: `https://aur.archlinux.org/packages/opentodolist/`
  - IzzyOnDroid: `https://apt.izzysoft.de/fdroid/index/apk/net.rpdev.opentodolist`
- Source/project links:
  - GitLab project: `https://gitlab.com/rpdev/opentodolist`
  - GitLab issues: `https://gitlab.com/rpdev/opentodolist/-/issues`
  - GitHub mirror/releases links used by downloads
- Translation/support:
  - POEditor join link from README/donate page

## Suggested Migration Order

1. Decide final canonical site base URL and deployment target for the MkDocs
   manual.
2. Add missing MkDocs pages by migrating current README and Jekyll user-facing
   content:
   - installation pages
   - sync pages
   - privacy page
   - support/donate/contribute page
3. Reduce the top-level README to project overview, build/contribution links,
   and pointers to the canonical manual/site.
4. Migrate or preserve the release archive:
   - either import release posts into a MkDocs news/archive section,
   - or keep static generated pages and redirect from the new site.
5. Add redirects for all public Jekyll URLs that move.
6. Only after redirects and canonical pages exist, remove or retire the old
   Jekyll source.

## Open Decisions

- Should the new MkDocs site replace only the user manual, or also the whole
  public website at `https://opentodolist.rpdev.net`?
  - We will keep the current mkdocs project and "upgrade" it, making it the
    user facing documentation including release notes. The old Jekyll based
    site will be completely dropped.
- Should historical release posts be migrated into MkDocs, kept as static
  archive pages, or redirected to GitHub/GitLab releases?
  - We'll try to migrate everything - for historic reasons, it'd be nice
    to have everything easily available.
- Should the privacy policy live in the manual navigation, a footer-only page,
  or a separate legal section?
  - We should add a link in the footer. However, the old URL shall remain
    unchanged - we link to it from external resources.
- Should Read the Docs remain the public documentation host, or should the site
  be deployed elsewhere?
  - We will host the documentation at opentodolist.rpdev.net. We will also keep
    readthedocs - as it nicely allows going back in time (aka versions).
