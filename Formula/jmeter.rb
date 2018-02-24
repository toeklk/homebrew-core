class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=jmeter/binaries/apache-jmeter-4.0.tgz"
  sha256 "845b8325726171a991cc13072275ec64b2ce4bbc6fa8e2aa350b2369e27e76b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "d84d0d4c55bf86a226394b7ef38edb5fe222ccc4c4062bc694c7d7ee4245090f" => :high_sierra
    sha256 "d84d0d4c55bf86a226394b7ef38edb5fe222ccc4c4062bc694c7d7ee4245090f" => :sierra
    sha256 "d84d0d4c55bf86a226394b7ef38edb5fe222ccc4c4062bc694c7d7ee4245090f" => :el_capitan
  end

  option "with-plugins", "add JMeterPlugins Standard, Extras, ExtrasLibs, WebDriver and Hadoop"

  resource "jmeterplugins-standard" do
    url "https://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.4.0.zip"
    sha256 "3f740bb9b9a7120ed72548071cd46a5f92929e1ab196acc1b2548549090a2148"
  end

  resource "serveragent" do
    url "https://jmeter-plugins.org/downloads/file/ServerAgent-2.2.1.zip"
    sha256 "2d5cfd6d579acfb89bf16b0cbce01c8817cba52ab99b3fca937776a72a8f95ec"
  end

  resource "jmeterplugins-extras" do
    url "https://jmeter-plugins.org/downloads/file/JMeterPlugins-Extras-1.4.0.zip"
    sha256 "de35e653250882268aa24d011ec0f2afbc13e1c552fbb676c67515bc80ef3194"
  end

  resource "jmeterplugins-extraslibs" do
    url "https://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-1.4.0.zip"
    sha256 "81d600a5bda6fdb362573d55c11208b2635728a2c18b7f647b9c7413c0f33ef3"
  end

  resource "jmeterplugins-webdriver" do
    url "https://jmeter-plugins.org/downloads/file/JMeterPlugins-WebDriver-1.4.0.zip"
    sha256 "521c2f7d452a84099407534bd50f29fd3761aa8a5beca52966bb9731e33b03e2"
  end

  resource "jmeterplugins-hadoop" do
    url "https://jmeter-plugins.org/downloads/file/JMeterPlugins-Hadoop-1.4.0.zip"
    sha256 "93030738d613748a685764fbfff0fe00ad2e161f2b72df6365294adc88db09b4"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jmeter"

    if build.with? "plugins"
      resource("jmeterplugins-standard").stage do
        rm_f Dir["lib/ext/*.bat"]
        (libexec/"lib/ext").install Dir["lib/ext/*"]
        (libexec/"licenses/plugins/standard").install "LICENSE", "README"
      end
      resource("serveragent").stage do
        rm_f Dir["*.bat"]
        rm_f Dir["lib/*winnt*"]
        rm_f Dir["lib/*solaris*"]
        rm_f Dir["lib/*aix*"]
        rm_f Dir["lib/*hpux*"]
        rm_f Dir["lib/*linux*"]
        rm_f Dir["lib/*freebsd*"]
        (libexec/"serveragent").install Dir["*"]
      end
      resource("jmeterplugins-extras").stage do
        (libexec/"lib/ext").install Dir["lib/ext/*.jar"]
        (libexec/"licenses/plugins/extras").install "LICENSE", "README"
      end
      resource("jmeterplugins-extraslibs").stage do
        (libexec/"lib/ext").install Dir["lib/ext/*.jar"]
        (libexec/"lib").install Dir["lib/*.jar"]
        (libexec/"licenses/plugins/extras").install "LICENSE", "README"
      end
      resource("jmeterplugins-webdriver").stage do
        (libexec/"lib/ext").install Dir["lib/ext/*.jar"]
        (libexec/"lib").install Dir["lib/*.jar"]
        (libexec/"licenses/plugins/extras").install "LICENSE", "README"
      end
      resource("jmeterplugins-hadoop").stage do
        (libexec/"lib/ext").install Dir["lib/ext/*.jar"]
        (libexec/"lib").install Dir["lib/*.jar"]
        (libexec/"licenses/plugins/extras").install "LICENSE", "README", "NOTICE"
      end
    end
  end

  test do
    system "#{bin}/jmeter", "--version"
  end
end
