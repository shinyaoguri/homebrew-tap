class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.7.2/metaphor-cli_v0.7.2_source.tar.gz"
  sha256 "e8a1e43a99c1ae56c9b99e32bbe8e82e75feff6144d68822bdde4a1da36e637e"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.7.2"
    rebuild 1
    sha256 arm64_tahoe:   "1f5619beda0a3b46dcdbcfba1c2287a066d8c0a4dc17bbfb8eb095d7da265c53"
    sha256 arm64_sequoia: "2aaf06ecec4bec2ff88586e3f3fb3f55e33c31d7493c3b7dc577254bc8caf992"
    sha256 arm64_sonoma:  "b32120f588bc040d4f947a3a0eec9f7c319803769bc82dcce1c267b55c4b1de7"
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
