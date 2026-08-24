class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.23.2/metaphor-cli_v0.23.2_source.tar.gz"
  sha256 "678c39b315e52e51100c586889f9bba39948655785e8362705fa9518287f9300"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.23.2"
    sha256 arm64_tahoe:   "629bac6319ddb6fd26731e7fb6ef1dc5a9bb9d9201f4494a5e62704b3f94b4de"
    sha256 arm64_sequoia: "2c3eb59e17cf917a72db7f81399a6782d4d04e6e4a1eb6f2cc1f3994a065db7a"
    sha256 arm64_sonoma:  "ca69683c903bacf1a3c403373e4c3a21c9dc05d032b5ab18c88c99188e941db7"
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
