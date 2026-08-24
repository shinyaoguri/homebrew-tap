class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.22.0/metaphor-cli_v0.22.0_source.tar.gz"
  sha256 "57cf3619610bfa8f5c4a933e6a9343399eef7bb2683c9b0b29f123ce1117aafe"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.22.0"
    sha256 arm64_tahoe:   "4a846182292964529af9fe71fa1d2353b4ecb1adc0e6af8c5b4fce6c1018fa31"
    sha256 arm64_sequoia: "ad93ab95f30760cc5e654b3040b2545dec8deff14072cbe25c53aec1f55658f2"
    sha256 arm64_sonoma:  "f32a265257a0946624db220ea313858f3fa62f08bae30de7a1bdf738573aba54"
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
