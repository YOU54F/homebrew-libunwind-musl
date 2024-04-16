class LibunwindI586Musl < Formula
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
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "47d910699e15c786d44dce9a54df652e392dce8afa92d7158ef717ef45100dcb"
    end
  
    keg_only "libunwind conflicts with LLVM"
  
    depends_on "xz"
    depends_on "zlib"
  
    def install
      system "./configure", *std_configure_args, "CC=/opt/homebrew/bin/i586-linux-musl-gcc", "--host=i586-unknown-linux-musl", "--target=i586-unknown-linux-musl","--disable-tests","--disable-shared"
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
      system "i586-linux-musl-gcc", "-I#{include}", "test.c", "-L#{lib}", "-lunwind", "-o", "test"
      system "./test"
    end
  end