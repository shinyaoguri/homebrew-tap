class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.23.1/metaphor-cli_v0.23.1_source.tar.gz"
  sha256 "1af61733b051a354a8c5e87f3fe43bb2e31be4d83a27707509620b471833ca66"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.23.1"
    sha256 arm64_tahoe:   "5b836407a3ab4556d3cc01174e9d1c4298fa8c3473a36c330f7e29c0aaa20a07"
    sha256 arm64_sequoia: "5740a560217d73e6508294f57ad5e3a7f13f93a24b43e6ce19c0d5d83f3fcb24"
    sha256 arm64_sonoma:  "0a7b0fbafbf6ed117fe4c609fbc112c6517768c6d4578fd6929fb24527b3476f"
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
