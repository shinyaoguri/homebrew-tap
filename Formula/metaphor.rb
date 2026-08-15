class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.10.3/metaphor-cli_v0.10.3_source.tar.gz"
  sha256 "0a3ae35557c05a3266631c4f92c48c634913223e522a7541cda4d1daa8adaf4f"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.10.3"
    sha256 arm64_tahoe:   "17645c9e47e009a1b014c32b9d14e06f730ad6e457a103e04d71c7dcbb66ba0a"
    sha256 arm64_sequoia: "55bb9c4cbe23010daf2e69f8e7bbf91085e9c126f688dd32d01f897b10403541"
    sha256 arm64_sonoma:  "8ee8362f29d2d9de76f2ef704ee31118b4fd281cba120a7574a609230b749a03"
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
