class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.20.0/metaphor-cli_v0.20.0_source.tar.gz"
  sha256 "d681a6000066c2aedf6cda38b2d14058586b1346c826754d0607e53c935f3a63"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.20.0"
    sha256 arm64_tahoe:   "d836b041885c6226c1fd949ad7cd5225ca37623a4753f272116ad6c08919b319"
    sha256 arm64_sequoia: "c74c7c3bc121983d68c9b4dac17f16ed7e13a3dfa067f2d647767a8bbb1f48d3"
    sha256 arm64_sonoma:  "5c0373b785317ddc08a3c1718eca66ad41603c88d593b56ff0e1f56fc79e9d23"
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
