class LibunwindI486Musl < Formula
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
    #   sha256 cellar: :any_skip_relocation, arm64_sonoma: "05eb9a14d1d773ff1947c19b2b091d14ea937dd4e8fadb640057950e0f9c1733"
    # end
  
    keg_only "libunwind conflicts with LLVM"
  
    depends_on "xz"
    depends_on "zlib"
    depends_on "filosottile/musl-cross/musl-cross" => :build
  
    def install
      system "./configure", *std_configure_args, "CC=i486-linux-musl-gcc", "--host=i486-unknown-linux-musl", "--target=i486-unknown-linux-musl","--disable-tests","--disable-shared"
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
      system "i486-linux-musl-gcc", "-I#{include}", "test.c", "-L#{lib}", "-lunwind", "-o", "test"
      system "./test"
    end
  end