class Duply < Formula
  desc "Frontend to the duplicity backup system"
  homepage "http://duply.net"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.0.x/duply_2.0.4.tgz"
  sha256 "efa450b976ff94d29b8f22b99d98aae108e032186c01ffdc526c85c87813048c"

  bottle :unneeded

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system "#{bin}/duply", "-v"
  end
end
