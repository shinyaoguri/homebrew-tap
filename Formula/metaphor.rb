class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.10.2/metaphor-cli_v0.10.2_source.tar.gz"
  sha256 "c592904f0844fb2f825e07f5941b01500dfa0c0479e988cd2d675c9f2eb70182"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.10.2"
    sha256 arm64_tahoe:   "e01b827c0b3aa583698d97328794bac563c0d5f792e33b01ab1bbbd833921dd7"
    sha256 arm64_sequoia: "6611115f5d3c894705d27fa25a11e245df606962fda97b74aa60ffdc338fd4ee"
    sha256 arm64_sonoma:  "ecd404cd8c86e72a81db2b26ab17d819c0a50e87b5fb843c6ec131c946087d89"
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
