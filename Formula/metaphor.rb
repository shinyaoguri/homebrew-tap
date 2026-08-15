class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.10.0/metaphor-cli_v0.10.0_source.tar.gz"
  sha256 "72924d4338814596a9e5f9c77faa433d4eb67b2404c73de9620c3eeb452d7ed7"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.10.0"
    sha256 arm64_tahoe:   "4e3f8bca13d7f5416e431d15cd074568714960844dc758545770d0a39cef069d"
    sha256 arm64_sequoia: "8d606419715c81c1749bfe5133cc643ecb2fd70e0f7ce52ec603e95006094737"
    sha256 arm64_sonoma:  "ce1d2d3dc5778fb79c173e0b9abf2111e351fcb43d32d1fbf093f67a247776f6"
  end

  depends_on xcode: ["15.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    # The binary links Syphon.framework via @rpath, resolved against @loader_path
    # (the directory of the *resolved* binary). Keep the framework beside the real
    # binary in libexec and expose the executable through a bin symlink — dyld
    # resolves the symlink before computing @loader_path, so it lands in libexec.
    libexec.install ".build/release/metaphor"
    libexec.install ".build/release/Syphon.framework"
    bin.install_symlink libexec/"metaphor"
    pkgshare.install "Templates" => "templates"
  end

  test do
    assert_match "metaphor", shell_output("#{bin}/metaphor version")
    assert_match "Templates:", shell_output("#{bin}/metaphor --help")
  end
end
