# Exercism's Lines of Code Counter

![Tests](https://github.com/exercism/lines-of-code-counter/workflows/Tests/badge.svg)

This is Exercism's Lines of Code (LoC) Counter.
It takes a solution and counts its lines of code using [tokei](https://github.com/XAMPPRocky/tokei).

## Choosing which files to include

We want to _only_ count the LoC of files that the student wrote.
We thus want to ignore:

- Documentation files (e.g. `README.md`)
- Configuration files (e.g. `metadata.json`)
- Test files
- Build files

By default, we'll only count the LoC of solution files.
These files are listed in the `files.solution` array of the exercise's `.meta/config.json` file.

While this is works well for most solutions, it doesn't work for:

- Old solutions which files were named differently
- Solutions where the student added additional files

Therefore, each track can define a track-specific configuration which allows also including non-solution files in the count.

### Track-specific configuration

To override the default configuration, each track can define a config file named `<slug>.tokeignore` inside the `lib/languages`directory (e.g. `languages/ruby.tokeignore`).
This config file defines the rules to determine which files' code should be counted for that track.
The files use the same [syntax](https://git-scm.com/docs/gitignore) as `.gitignore` files.

The starting point is to ignore all files:

```gitignore
# Ignore everything
*
```

The next step is to then selectively include all files that _could_ be solution files.
That could look like this:

```gitignore
# Un-ignore (include) .cs files
!*.cs
```

At this point, usually the only thing left to do is to re-ignore the test files:

```gitignore
# Ignore test files
*Tests.cs
```

With just these three rules, we now count the LoC of _all_ solution files, excluding the test files.

## Running the tests

TODO

## Credit

This repo is built and maintained by Exercism.

Contributions are welcome!
