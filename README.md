# Exercism's Lines of Code Counter

![Tests](https://github.com/exercism/lines-of-code-counter/workflows/Tests/badge.svg)

This is Exercism's Lines of Code (LoC) Counter.
It takes a solution and counts its lines of code using [tokei](https://github.com/XAMPPRocky/tokei).

## Choosing which files to include

We want to _only_ count the LoC of files that the student wrote.
We thus always ignore the following files:

- Test files (the `files.test` array in the exercise `.meta/config.json` file)
- Editor files (the `files.editor` array in the exercise `.meta/config.json` file)
- Example files (the `files.example` array in the exercise `.meta/config.json` file)
- Exemplar files (the `files.exemplar` array in the exercise `.meta/config.json` file)
- Files in hidden directories (e.g. `.docs/instructions.md` or `.meta/config.json`)

### Default configuration

The default configuration only counts the LoC of solution files (the `files.solution` array in the exercise `.meta/config.json` file).

While this does indeed exclude the above-mentioned files, it doesn't work well for:

- Old solutions which files were named differently
- Solutions where the student added additional files

Therefore, each track can define a track-specific configuration which allows also including non-solution files in the count.

### Track-specific configuration

To override the default configuration, each track can define a config file named `<slug>.tokeignore` inside the `lib/languages`directory (e.g. `languages/ruby.tokeignore`).
This config file defines the rules to determine which files' code should be counted for that track.
The files use the same [syntax](https://git-scm.com/docs/gitignore) as `.gitignore` files.

You don't have to explicitly exclude the above-mentioned test/editor/example/exemplar/documentation/configuration files.
We'll automatically exclude them for you.

#### Example

Here is an example track-specific configuration:

```gitignore
# Ignore everything
*

# Un-ignore .cs files
!*.fs
```

Before we actually count the lines of code, we'll automatically add the above-mentioned exclusions:

```gitignore
# Ignore everything
*

# Un-ignore .cs files
!*.fs

# Ignore files.test files
AnagramTests.fs

# Ignore files.example files
.meta/Example.fs
```

We'll then count the LoC using this configuration file to determine which files to count.

## Running the tests

TODO

## Credit

This repo is built and maintained by Exercism.

Contributions are welcome!
