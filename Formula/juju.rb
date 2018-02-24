class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.3/2.3.3/+download/juju-core_2.3.3.tar.gz"
  sha256 "98b13d76c34118da110d3bc50931de9b7aa69594ebf2cb18b37cb187a9ffc6dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed92d69d256a19ead50f139437f063e865008123b0c87d4be7b6fa3bbfc09fea" => :high_sierra
    sha256 "051b9e188b0e9bcda30364015ffd6bee5c03550e71600ff6b65f25fbbd7ecd23" => :sierra
    sha256 "4530a6f0b5a7c3d4242fadbcb9eebddfd29477eb219a066e943ab1173f4cc2e4" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
