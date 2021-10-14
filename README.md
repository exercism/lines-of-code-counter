# Exercism's Lines of Code Counter

![Tests](https://github.com/exercism/lines-of-code-counter/workflows/Tests/badge.svg)

This is Exercism's Lines of Code Counter.
It takes an exercism submission and counts its lines of code, minus documentation and tests.

## Add your track

Each track has a config file named `<slug>.tokeignore` inside the `lib/languages`directory, where `<slug>` is the track slug (e.g. `languages/ruby.tokeignore`).
This config file defines the rules to determine which files' code should be counted for that track.
The files use the same [syntax](https://git-scm.com/docs/gitignore) as `.gitignore` files.

## Running the tests

TODO

## Credit

This repo is built and maintained by Exercism.

Contributions are welcome!
