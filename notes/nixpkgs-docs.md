# [Setup Hooks Section](https://nixos.org/manual/nixpkgs/unstable/#ssec-setup-hooks)

* The combination of its power and implicit use may be expedient, but isn’t without costs. Nix itself is unchanged, but the spirit of added dependencies being effect-free is violated even if the *latter* isn’t.
* For example, if a derivation path is mentioned more than once, Nix itself doesn’t care and makes sure the dependency derivation is already built just the same—depending is just needing something to exist, and *needing is idempotent*.


