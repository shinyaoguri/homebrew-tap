class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.19.0/metaphor-cli_v0.19.0_source.tar.gz"
  sha256 "f6f9bceaf4430c1e81f42ad57e4ccd5401b9b790f19bf8fa124b351de02c7002"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.19.0"
    sha256 arm64_tahoe:   "947e73f47c448f40590c9d5bbca1e73384efd29818f68aa5f67df9a5d60db41c"
    sha256 arm64_sequoia: "4f092fe50c78c71c9a41ebbeb6885078654767e58351f522391a78d1beb732df"
    sha256 arm64_sonoma:  "ed15769640903a396d16226895e814000128bbe3212bbee7ae2e42790dab59ac"
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
