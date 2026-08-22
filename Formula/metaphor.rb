class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.16.0/metaphor-cli_v0.16.0_source.tar.gz"
  sha256 "a3ec00a697d850f59a7eed51d43ec98d316d58c8ec62b97d8de911ac32b52fc6"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.16.0"
    sha256 arm64_tahoe:   "49e43259d843b83f57766eb33ecd793c2354bb64344710dbcd8d777a650dd77c"
    sha256 arm64_sequoia: "16525bb74cc85c170da5c500090b5949b82197448fd44cbe4aa23cd0f5ef876c"
    sha256 arm64_sonoma:  "3c403d3ceac0e2aaa0ff208fa2d3f50ed78f902657e808ff5e2954827414d304"
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
