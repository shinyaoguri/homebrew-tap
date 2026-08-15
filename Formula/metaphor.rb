class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.10.4/metaphor-cli_v0.10.4_source.tar.gz"
  sha256 "1419bdbcb90bed01b6f655d5ce2c060f45d450135904b5de877f2cde22b4042c"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.10.4"
    sha256 arm64_tahoe:   "72391dbeab89215272fb2bb5e9b5517d3769614f032942cc169ad6fdb5569a98"
    sha256 arm64_sequoia: "24132b323cdb6d7091cd4fe8d6e103f33b8b77bcdcb8d8b4ce8cd357597274d0"
    sha256 arm64_sonoma:  "acd2288af0673f35edd9316993f0976f972ce3c94bd3b03426d768daba397bdf"
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
