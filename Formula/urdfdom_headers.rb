class UrdfdomHeaders < Formula
  desc "Headers for Unified Robot Description Format (URDF) parsers"
  homepage "https://wiki.ros.org/urdfdom_headers/"
  url "https://github.com/ros/urdfdom_headers/archive/1.0.0.tar.gz"
  sha256 "f341e9956d53dc7e713c577eb9a8a7ee4139c8b6f529ce0a501270a851673001"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b937204b1bd92e9c290dfc9df366c2978352be8551a47910ac637d863a6f585" => :high_sierra
    sha256 "3b937204b1bd92e9c290dfc9df366c2978352be8551a47910ac637d863a6f585" => :sierra
    sha256 "3b937204b1bd92e9c290dfc9df366c2978352be8551a47910ac637d863a6f585" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <urdf_model/pose.h>
      int main() {
        double quat[4];
        urdf::Rotation rot;
        rot.getQuaternion(quat[0], quat[1], quat[2], quat[3]);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
