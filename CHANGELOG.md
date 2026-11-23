# 1.3.2 (2026-11-23)

### Security

* Clear all Dependabot and audit alerts: update `@directus/extensions-sdk` to 17.1.4, `@directus/composables` to 11.4.1, `@directus/types` to 15.0.3, `@directus/utils` to 13.4.1 and `vue-i18n` to 11.4.14, and add pnpm overrides for axios, vite, zod, js-yaml, joi, nanoid, minimatch and deepmerge.
* Move `@vueuse/core` and `lodash` to devDependencies. They are bundled into `dist`, so the Directus image no longer installs them.

# [1.2.0](https://github.com/hanneskuettner/directus-extension-inline-form-interface/compare/v1.1.0...v1.2.0) (2024-03-07)


### Bug Fixes

* Permissions compatibility with Directus 10.9.1+ ([cc356d2](https://github.com/hanneskuettner/directus-extension-inline-form-interface/commit/cc356d2b964d5b6acf979105281dc20a1317e8e2))


### Features

* Bump dependencies ([7ed43ea](https://github.com/hanneskuettner/directus-extension-inline-form-interface/commit/7ed43eaca184f647e70296e325b253cee39fb6ad))

# [1.1.0](https://github.com/hanneskuettner/directus-extension-inline-form-interface/compare/v1.0.1...v1.1.0) (2023-05-09)


### Features

* **license:** change license to GPL-3.0 ([96def50](https://github.com/hanneskuettner/directus-extension-inline-form-interface/commit/96def50cad45484f1334e25b0868bc82fc42cc9d))

## [1.0.1](https://github.com/hanneskuettner/directus-extension-inline-form-interface/compare/v1.0.0...v1.0.1) (2023-05-04)


### Bug Fixes

* only include dist in package contents ([8cb9541](https://github.com/hanneskuettner/directus-extension-inline-form-interface/commit/8cb9541e9d1b2571d00324d53e92ac34cf8ecbcb))

# 1.0.0 (2023-05-04)


### Bug Fixes

* install correct semantic-release plugin ([4dc87a0](https://github.com/hanneskuettner/directus-extension-inline-form-interface/commit/4dc87a0d106af4d973f6247219d8b2d9fa756b59))


### Features

* first release ([68abc21](https://github.com/hanneskuettner/directus-extension-inline-form-interface/commit/68abc2159f52f84bd8a565d4d5cffce8f7d555f2))
