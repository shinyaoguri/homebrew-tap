class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.8.0/metaphor-cli_v0.8.0_source.tar.gz"
  sha256 "6e2f4b9924e1b430c611d3dc90774f1a9acc13556e42622f0df25d6839628e8f"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.8.0"
    sha256 arm64_tahoe:   "e5e21812b5ea0e25f5c97e91d40b7c8d8490667fb90711a9026ab0f80eccdc53"
    sha256 arm64_sequoia: "d8109d11d1b8a44932f25c6d1a91ead7bee096f03bf8e7f13e9819a68a8e6c49"
    sha256 arm64_sonoma:  "c667596b7b189729e3d101987bcd9e3fd62d9f22a628cf74524cba55d76fdaa4"
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
