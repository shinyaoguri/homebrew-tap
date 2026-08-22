class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.17.0/metaphor-cli_v0.17.0_source.tar.gz"
  sha256 "b8ecf192c6103114e29e4f258cf7d19b1032a76159dea373e88168c9a5e6e655"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.17.0"
    sha256 arm64_tahoe:   "f34b61963cf5a365532a063e70887f022f255c094dd3bf8571cf8146490ad802"
    sha256 arm64_sequoia: "8b66a543cd2bda95901f878f3b145a19fc12106467fbe647783b847727304ce2"
    sha256 arm64_sonoma:  "92b7bdbe8a84f9be98ffb608864f1ee578a11e2e17a8fb93092f18b0a8a072cc"
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
