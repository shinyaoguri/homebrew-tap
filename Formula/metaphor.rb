class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.15.0/metaphor-cli_v0.15.0_source.tar.gz"
  sha256 "46fb3551cebfb8dd33e9d5755038bd3833bbc7e0b545ee3e54e807328b98934b"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.15.0"
    sha256 arm64_tahoe:   "f6afe2b58ad41e14ea39f0f8d90d0cc937d9b66fd932820048f25250fbd9c9b6"
    sha256 arm64_sequoia: "067095ccfe146cff64463267693331662331fa1bf0fe0be6defd62000279ae80"
    sha256 arm64_sonoma:  "c2fe7a5a30522a20c2ba6ccaf8a1229cfbbf94e26508b390d23ef4239c1fd2ae"
  end

  depends_on xcode: ["15.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    # Keep the real binary in libexec and expose it through a bin symlink — the
    # same layout as scripts/install.sh and `metaphor update self`, so every
    # install method resolves the binary to one place.
    libexec.install ".build/release/metaphor"
    bin.install_symlink libexec/"metaphor"
    pkgshare.install "Templates" => "templates"
  end

  test do
    assert_match "metaphor", shell_output("#{bin}/metaphor version")
    assert_match "Templates:", shell_output("#{bin}/metaphor --help")
  end
end
