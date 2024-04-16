class LibunwindAarch64Musl < Formula
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "3be55eb5f389f6bf941092c91b79ff1bc1471863f839775653b240480737a044"
  end

  keg_only "libunwind conflicts with LLVM"

  depends_on "filosottile/musl-cross/musl-cross" => :build
  depends_on "xz"
  depends_on "zlib"

  def install
    system "./configure", *std_configure_args, "CC=aarch64-linux-musl-gcc", "--host=aarch64-unknown-linux-musl",
"--target=aarch64-unknown-linux-musl", "--disable-tests", "--disable-shared"
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
    system "aarch64-linux-musl-gcc", "-I#{include}", "test.c", "-L#{lib}", "-lunwind", "-o", "test"
    system "./test"
  end
end
