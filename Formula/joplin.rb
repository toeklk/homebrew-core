require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.99.tgz"
  sha256 "65b1d6c8d0711ad5bd20000f5c7642a7016f2562eeb5c53ef0d48120d3343352"

  bottle do
    sha256 "bb094c22cfb89d955160e094534e59a50d26718d3ac4eb52d879b1bd2ca1e05f" => :high_sierra
    sha256 "e754e545fa3bf577f9e97774f1ff558589e966b600c39573eb651576a7e11fb6" => :sierra
    sha256 "be8ff7aa62a79527fb20d43638d36b7344472466a50587577e80fbf4040850fb" => :el_capitan
  end

  depends_on "node"
  depends_on "python" => :build if MacOS.version <= :snow_leopard

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
