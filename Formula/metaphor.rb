class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.21.0/metaphor-cli_v0.21.0_source.tar.gz"
  sha256 "e79f439944202bd32ea90bc444204a279172bd407baf0d78755672e565da8401"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.21.0"
    sha256 arm64_tahoe:   "ddbc2a111f29c3984b4d455f1cb6343f0bf1fe2caea79cfcc23cf2438e3aa295"
    sha256 arm64_sequoia: "0a0ff8ec21b37188ccc3fdeef76a46999495f61c3548087326ea9fc74d263d03"
    sha256 arm64_sonoma:  "cd3ba0427b21731af7b7d17d276ac39c8810f84eedc536132c4f29da5064825c"
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
