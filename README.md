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

#### Renamed files

It's worth noting that older solutions might be using a different naming scheme than specified in the `files` key in the `.meta/config.json` file.
If your track has done a file renaming at some point, consider

##### Example

The F# track used to have test files that ended with `Test.fs` (singular), but nowadays uses `Tests.fs` (plural).
The files in the `files.test` key all end with `Tests.fs` (the file was created _after_ the rename), but old solutions will have test files that don't match those file names.
To prevent these test files to be included in the LoC count, we can append the following line to the F# track's configuration file:

```gitignore
# Ignore old test files
*Test.fs
```

## Running the tests

TODO

## Credit

This repo is built and maintained by Exercism.

Contributions are welcome!
