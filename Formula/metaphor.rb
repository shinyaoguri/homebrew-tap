class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.11.0/metaphor-cli_v0.11.0_source.tar.gz"
  sha256 "069f5b1285199a981cc83462317ef4cffaa02c21f9642ff0ed04f35f98ca6f42"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.11.0"
    sha256 arm64_tahoe:   "15edb747988c0d26aa4f8ed260787dc17e2896ec7c41fd21a46aab66354d373b"
    sha256 arm64_sequoia: "975875a64be5a702023812828180c5ddbfc2e1abb0318b783b95a9be3e6ef84d"
    sha256 arm64_sonoma:  "7cb1adfa4429f6e95f23dfc2f2afc62d8153c9077cdee3baca3ea871f8edc8b2"
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
