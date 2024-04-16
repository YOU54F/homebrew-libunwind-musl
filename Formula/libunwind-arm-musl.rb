class LibunwindArmMusl < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://www.nongnu.org/libunwind/"
  url "https://github.com/libunwind/libunwind/releases/download/v1.8.1/libunwind-1.8.1.tar.gz"
  sha256 "ddf0e32dd5fafe5283198d37e4bf9decf7ba1770b6e7e006c33e6df79e6a6157"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # bottle do
  #   sha256 cellar: :any_skip_relocation, x86_64_linux: "81f89b76defac2b351bfb10864fcb7a9169b126f6e62a0c37c235873034fea7d"
  # end

  keg_only "libunwind conflicts with LLVM"

  depends_on "xz"
  depends_on "zlib"
  depends_on "filosottile/musl-cross/musl-cross" => :build

  def install
    system "./configure", *std_configure_args, "CC=arm-linux-musleabi-gcc", "--host=armv7-unknown-linux-musleabi", "--target=armv7-unknown-linux-musleabi","--disable-tests","--disable-shared"
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
    system "arm-linux-musleabi-gcc", "-I#{include}", "test.c", "-L#{lib}", "-lunwind", "-o", "test"
    system "./test"
  end
end