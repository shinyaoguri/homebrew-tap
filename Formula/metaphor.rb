class Metaphor < Formula
  desc "Command-line tools for the metaphor Swift + Metal creative coding library"
  homepage "https://github.com/shinyaoguri/metaphor-cli"
  url "https://github.com/shinyaoguri/metaphor-cli/releases/download/v0.1.1/metaphor-cli_v0.1.1_source.tar.gz"
  sha256 "9454fdd08dea6326ca1d2632b6af57454a830c4e6c0c211be6fb8b7fd346ea83"
  license "MIT"
  head "https://github.com/shinyaoguri/metaphor-cli.git", branch: "main"

  depends_on xcode: ["15.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/metaphor"
    pkgshare.install "Templates" => "templates"
  end

  test do
    assert_match "metaphor", shell_output("#{bin}/metaphor version")
    assert_match "Templates:", shell_output("#{bin}/metaphor --help")
  end
end
