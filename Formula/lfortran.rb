class Lfortran < Formula
  desc "Modern interactive LLVM-based Fortran compiler"
  homepage "https://lfortran.org"
  url "https://lfortran.github.io/tarballs/release/lfortran-0.46.0.tar.gz"
  sha256 "420885b4bcfd2206bc5ae9cdb658f2382b35b0e4d145476a97bdc7d642d4a588"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/fortran-lang/homebrew-fortran/releases/download/lfortran-0.46.0"
    rebuild 1
    sha256 cellar: :any, arm64_sonoma: "18463218cdd1a5fc09b468f27051b55a03c8c693c73aff6b3a6696cc439c2f59"
    sha256 cellar: :any, ventura:      "62dc18247373cd3ec6364783e8e3e645d246e64b8a72026a3be6eca3f892f227"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "llvm"
  depends_on "z3"
  depends_on "zlib"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DCMAKE_CXX_FLAGS_RELEASE=-O3 -funroll-loops -DNDEBUG"
    cmake_args << "-DWITH_LLVM=ON"
    system "cmake", *cmake_args, "-G", "Ninja", "-B", "build"
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--output-on-failure"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"lfortran", "--version"
    (testpath/"hello.f90").write <<~EOS
      program hello
        print *, "Hello, World!"
      end
    EOS
    system bin/"lfortran", testpath/"hello.f90", "-o", testpath/"hello"
    assert_path_exists testpath/"hello"
    system testpath/"hello"
  end
end
