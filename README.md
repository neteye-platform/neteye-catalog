# NetEye Operator Catalog

This repository contains the file-based OLM v1 catalog for the NetEye Operator.
The operator repository builds and publishes the OLM bundle image referenced by
`catalog/index.yaml`; update this catalog only after that bundle image is
available in the registry.

## Publishing model

Bundles are immutable: an operator release publishes a matching bundle image,
such as `neteye-operator-bundle:0.1.0`, and the catalog references that exact
version. The catalog image is mutable on the `main` branch: each push publishes
`neteye-catalog:latest`, which the `ClusterCatalog` polls for updates.

The `stable` channel is defined in `catalog/index.yaml`. Add each released
bundle to that channel and maintain the bundle CSV upgrade graph before merging
the catalog change to `main`.

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
