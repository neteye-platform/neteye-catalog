# NetEye Catalog

This repository contains the file-based OLM v1 catalog for the NetEye Product.

## Publishing model

Bundles are immutable: an operator release publishes a matching bundle image,
such as `neteye-operator-bundle:0.1.0`, and the catalog references that exact
version. The catalog image is mutable on the `main` branch: each push publishes
`neteye-catalog:latest`, which the `ClusterCatalog` polls for updates.

## Catalog layout

The catalog holds one file per FBC blob, under a directory per package:

```text
catalog/
└── neteye-operator/
    ├── package.yaml              # olm.package
    ├── channels/
    │   ├── 4.50-nightly.yaml     # olm.channel, one file per channel
    │   ├── 4.50-stable.yaml
    │   ├── 4.51-nightly.yaml
    │   └── 4.51-stable.yaml
    └── bundles/
        ├── 0.2.3.yaml            # olm.bundle, one file per release
        ├── …
        └── nightly.yaml          # every nightly olm.bundle, appended
```

`opm` loads the tree recursively and each file may hold several
`---`-separated blobs, so this serves exactly what a single concatenated index
would.

Releases get a file each: they are permanent, few, and worth reviewing on their
own. Nightlies are published every night, so a file each would add a file per
day; they share `bundles/nightly.yaml`, which the nightly build appends to. The
release workflow never writes that file and the nightly workflow never writes a
release file, so the two automations cannot conflict — which is why the catalog
is split in the first place.

Channels are named `<neteye-line>-<maturity>` and are never repointed at a
different NetEye release line, per ADR-0003 in the operator repository. Both
channel kinds are written by the operator repository's release automation; add
each released bundle to its channel and keep the upgrade graph consistent
before merging to `main`.

Stable channels carry a linear `replaces` chain, so upgrades step through every
release. Nightly channels are rolling: every entry is a plain name and only the
channel head carries `replaces` plus a `skips` list of the remaining
predecessors, so an installation can jump to the newest nightly from any older
one. Writing the skips on the head alone keeps the channel linear in size — the
earlier scheme repeated the full predecessor list on every entry, which grew as
n(n−1)/2 and had reached 379 lines for 26 nightlies.

## Validate and build locally

```sh
make validate
make build
```

The produced image is consumed by the NetEye Operator Helm chart through a
`ClusterCatalog` resource.

## License

Dual-licensed under either the [Apache License 2.0](LICENSE-APACHE) or the
[MIT license](LICENSE-MIT), at your option.
Copyright © Würth IT Italy S.r.l.
