class LibunwindI386Musl < Formula
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "caf4709fccfac69ef25f78db8022bafa6c8d49d92bc66a74e9a91a003754e4bc"
  end

  keg_only "libunwind conflicts with LLVM"

  depends_on "filosottile/musl-cross/musl-cross" => :build
  depends_on "xz"
  depends_on "zlib"

  def install
    system "./configure", *std_configure_args, "CC=i386-linux-musl-gcc", "--host=i386-unknown-linux-musl",
"--target=i386-unknown-linux-musl", "--disable-tests", "--disable-shared"
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
    system "i386-linux-musl-gcc", "-I#{include}", "test.c", "-L#{lib}", "-lunwind", "-o", "test"
    system "./test"
  end
end
