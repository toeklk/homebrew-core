class Vdirsyncer < Formula
  include Language::Python::Virtualenv

  desc "Synchronize calendars and contacts"
  homepage "https://github.com/pimutils/vdirsyncer"
  url "https://github.com/pimutils/vdirsyncer.git",
      :tag => "0.16.4",
      :revision => "c63e55d0201fbfed23287216e7f8e19ff34d5ac3"
  head "https://github.com/pimutils/vdirsyncer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ce393b3faeda5ae2dbe09d1c6191061217e6651da3b4ae39428cfe62aa988b9" => :high_sierra
    sha256 "5471356eb616352787dad823a1a76a8f54bbbcacd1162dc8d0191e4eaf90ff5c" => :sierra
    sha256 "c88fa9fe7b8ae024b0046a5eceea3b715cf4e9da6588a08db9fb27dbaf9058f5" => :el_capitan
  end

  depends_on "python3"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "requests-oauthlib",
                              buildpath
    system libexec/"bin/pip", "uninstall", "-y", "vdirsyncer"
    venv.pip_install_and_link buildpath

    prefix.install "contrib/vdirsyncer.plist"
    inreplace prefix/"vdirsyncer.plist" do |s|
      s.gsub! "@@WORKINGDIRECTORY@@", bin
      s.gsub! "@@VDIRSYNCER@@", bin/name
      s.gsub! "@@SYNCINTERVALL@@", "60"
    end
  end

  def post_install
    inreplace prefix/"vdirsyncer.plist", "@@LOCALE@@", ENV["LC_ALL"] || ENV["LANG"] || "en_US.UTF-8"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/".config/vdirsyncer/config").write <<~EOS
      [general]
      status_path = "#{testpath}/.vdirsyncer/status/"
      [pair contacts]
      a = "contacts_a"
      b = "contacts_b"
      collections = ["from a"]
      [storage contacts_a]
      type = "filesystem"
      path = "~/.contacts/a/"
      fileext = ".vcf"
      [storage contacts_b]
      type = "filesystem"
      path = "~/.contacts/b/"
      fileext = ".vcf"
    EOS
    (testpath/".contacts/a/foo/092a1e3b55.vcf").write <<~EOS
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name Ö φ 風 ض
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    (testpath/".contacts/b/foo/").mkpath
    system "#{bin}/vdirsyncer", "discover"
    system "#{bin}/vdirsyncer", "sync"
    assert_match /Ö φ 風 ض/, (testpath/".contacts/b/foo/092a1e3b55.vcf").read
  end
end
