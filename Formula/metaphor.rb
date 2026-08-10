class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.7.2/metaphor-cli_v0.7.2_source.tar.gz"
  sha256 "e8a1e43a99c1ae56c9b99e32bbe8e82e75feff6144d68822bdde4a1da36e637e"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/shinyaoguri/homebrew-tap/releases/download/metaphor-0.7.2"
    sha256 arm64_tahoe:   "26c418efa65ba801e4163daf3417377a1a720741b3cf04b2744734549fe34aa5"
    sha256 arm64_sequoia: "dcf3ea953b7633727ccb78d120c315859c8f336d2b8211ed5bae6aee7fa110fd"
    sha256 arm64_sonoma:  "725fb54c09a4a6d82e5943ed78e8643359f636e37ade4393a7746b426ea5f8a8"
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
