class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.19.2/metaphor-cli_v0.19.2_source.tar.gz"
  sha256 "eefb9a87ffeba7fa5f9e4b06f7f3392fc8f1f5f93462bbb713f990f1b4ff134d"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.19.2"
    sha256 arm64_tahoe:   "1a40d207c9259e53d83656150efc8576b7df0183d932b6ca80dd2d8cb32e4fed"
    sha256 arm64_sequoia: "3af6e26aa60b2d3ed16583b987118d944a4fc011ef798a69fc69a71308855212"
    sha256 arm64_sonoma:  "8730b9759f1a11c176cc97f76ec4678af287a63d18898aaa1a3426b743dd785b"
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
