class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.10.1/metaphor-cli_v0.10.1_source.tar.gz"
  sha256 "e7d82b8547d6b31c6860089ff88f541dc7a44c310e186432321445d241ac0b48"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.10.1"
    sha256 arm64_tahoe:   "f9bcb592f7716209bb02f24870ae4c6be3043a0269fde153be4cb87a59b52c51"
    sha256 arm64_sequoia: "29e965443e648e760fa371d913963113e8ae2720428be2880e9fba613045d681"
    sha256 arm64_sonoma:  "31114a784baf0f72b12091cc6f0ac1d937a2bdd44d9427becd29c538a6d732e3"
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
