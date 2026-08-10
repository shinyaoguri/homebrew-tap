# Shinyaoguri Tap

Homebrew tap for [metaphor](https://github.com/shinyaoguri/metaphor), a Swift +
Metal creative coding library, and its CLI
([metaphor-cli](https://github.com/shinyaoguri/metaphor-cli)).

## How do I install these formulae?

```bash
brew install shinyaoguri/tap/metaphor
```

Or `brew tap shinyaoguri/tap` and then `brew install metaphor`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "shinyaoguri/tap"
brew "metaphor"
```

The formula is named `metaphor` (after the command it installs), while the
source repository is `metaphor-cli` — right after installing you can run
`metaphor new` to start a sketch.

## How this tap is maintained

Everything here is updated automatically — **do not edit
`Formula/metaphor.rb` by hand**:

1. A stable [metaphor-cli release](https://github.com/shinyaoguri/metaphor-cli/releases)
   opens a Formula PR against this tap.
2. `brew test-bot` builds the formula and generates bottles on the PR.
3. When green, `publish.yml` merges it into `main` with bottles attached
   (bottles are hosted on this repository's own GitHub Releases).

Details live upstream:

- [metaphor-cli docs/homebrew.md](https://github.com/shinyaoguri/metaphor-cli/blob/main/docs/homebrew.md)
  — formula source, bottles, tap credentials (the canonical doc for this tap)
- [metaphor docs/release-pipeline.md](https://github.com/shinyaoguri/metaphor/blob/main/docs/release-pipeline.md)
  — how all three repositories connect and release together (Japanese)

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
