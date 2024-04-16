class LibunwindPowerpc64leMusl < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://www.nongnu.org/libunwind/"
  url "https://github.com/libunwind/libunwind/releases/download/v1.8.1/libunwind-1.8.1.tar.gz"
  sha256 "ddf0e32dd5fafe5283198d37e4bf9decf7ba1770b6e7e006c33e6df79e6a6157"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "5f497d4367528026f8134417a78031b1e20dd888e0b601694f8520de46aca2ca"
  end

  keg_only "libunwind conflicts with LLVM"

  depends_on "filosottile/musl-cross/musl-cross" => :build
  depends_on "xz"
  depends_on "zlib"

  def install
    system "./configure", *std_configure_args, "CFLAGS=-fPIC -g -O2 -m64", "CXXFLAGS=-g -O2 -m64",
"CC=powerpc64le-linux-musl-gcc", "--host=powerpc64le-unknown-linux-musl",
"--target=powerpc64le-unknown-linux-musl", "--disable-tests",
"--disable-shared", "--disable-ptrace"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libunwind.h>
      int main() {
        unw_context_t uc;
        unw_getcontext(&uc);
        return 0;
      }
    EOS
    system "powerpc64le-linux-musl-gcc", "-I#{include}", "test.c", "-L#{lib}", "-lunwind", "-o", "test"
    system "./test"
  end
end
