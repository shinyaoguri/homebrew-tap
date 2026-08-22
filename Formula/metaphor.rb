class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.14.0/metaphor-cli_v0.14.0_source.tar.gz"
  sha256 "1e4eeecab0889db6fcc22998c7ad3cfaf4b0ef729058143f9de69dcfad6a384a"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.14.0"
    sha256 arm64_tahoe:   "95f44234057062832b49ae384c56c8ba74f98a1c30fe652586a9fb3841f969d3"
    sha256 arm64_sequoia: "ed1a4e04e8ffbc5e23f8a601946fbcbbe01860135f10f1ad8e4f90ba6c16da97"
    sha256 arm64_sonoma:  "d62a729083b6b5da5b89a372548142ce6e2d4b79b04792422c395e1cb5237c27"
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
