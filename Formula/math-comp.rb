class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.6.4.tar.gz"
  sha256 "c672a4237f708b5f03f1feed9de37f98ef5c331819047e1f71b5762dcd92b262"
  revision 1
  head "https://github.com/math-comp/math-comp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7801ad3b348b574bc81c1079cf7606783363af1cc8aac2af4bc5b81df5f7747" => :high_sierra
    sha256 "fcb4e065518406f6dcfca6580d0cf1da7b2d7063dd164e27859a98b11f515ae3" => :sierra
    sha256 "fcb4e065518406f6dcfca6580d0cf1da7b2d7063dd164e27859a98b11f515ae3" => :el_capitan
  end

  depends_on "ocaml" => :build
  depends_on "coq"

  def install
    coqbin = "#{Formula["coq"].opt_bin}/"
    coqlib = "#{lib}/coq/"

    (buildpath/"mathcomp/Makefile.coq.local").write <<~EOS
      COQLIB=#{coqlib}
    EOS

    cd "mathcomp" do
      system "make", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}", "COQBIN=#{coqbin}"
      system "make", "install", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}", "COQBIN=#{coqbin}"

      elisp.install "ssreflect/pg-ssr.el"
    end

    system "make", "-C", "htmldoc", "COQBIN=#{coqbin}" if build.head?

    doc.install Dir["htmldoc/*"]
  end

  test do
    (testpath/"testing.v").write <<~EOS
      From mathcomp Require Import ssreflect seq.

      Parameter T: Type.
      Theorem test (s1 s2: seq T): size (s1 ++ s2) = size s1 + size s2.
      Proof. by elim : s1 =>//= x s1 ->. Qed.

      Check test.
    EOS

    coqc = Formula["coq"].opt_bin/"coqc"
    cmd = "#{coqc} -R #{lib}/coq/user-contrib/mathcomp mathcomp testing.v"
    assert_match /\Atest\s+: forall/, shell_output(cmd)
  end
end
