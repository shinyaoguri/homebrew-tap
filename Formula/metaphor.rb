class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.23.0/metaphor-cli_v0.23.0_source.tar.gz"
  sha256 "65962516b41bc9fcb6439da2d0279e534e715f175d701d223f32761ed4a060e4"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.23.0"
    sha256 arm64_tahoe:   "2835db72055301bd3479d73dd5e5294187bd201d37b8119a28cb8b7907a33705"
    sha256 arm64_sequoia: "fd6899768755ccfaa93414d49ca0b304e1f0ce41c06d5aeca3d2a8b357d82553"
    sha256 arm64_sonoma:  "1828d1a2fcb7e9b4d88f73cbc6f8353555d98366acc63ec20f344c0b5cdb8c99"
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
