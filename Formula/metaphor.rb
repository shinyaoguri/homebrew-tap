class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.19.1/metaphor-cli_v0.19.1_source.tar.gz"
  sha256 "2a372d08e22dc2b20a14c38539ef9c0b8f0151c5cc7e2ad2fbba06727aa5e470"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.19.1"
    sha256 arm64_tahoe:   "642f388e1a414acd32cca3fe9627b48f6b264ed3155402b355d0f4d14ec11bb3"
    sha256 arm64_sequoia: "17cfafd4a9e663efa8eb1bc15ba9cf8a04f280c13da788a45bc1cce85d8e1fcf"
    sha256 arm64_sonoma:  "2970a8ca04640779794934abb1f9051bccb13e7c9eda668a5d8e0f565b282d59"
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
