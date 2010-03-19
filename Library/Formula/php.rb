require 'formula'

class Libiconv <Formula
  @url='http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz'
  @homepage='http://www.gnu.org/software/libiconv/'
  @md5='7ab33ebd26687c744a37264a330bbe9a'
end

class Php <Formula
  @url='http://ca3.php.net/get/php-5.3.2.tar.gz/from/us.php.net/mirror'
  @homepage='http://php.net'
  @md5='4480d7c6d6b4a86de7b8ec8f0c2d1871'
  @version='5.3.2'

  def options
    []
  end

  def install
    # Won't compile with Snow Leopard's libiconv
    iconvd = Pathname.getwd+'iconv'
    iconvd.mkpath

    Libiconv.new.brew do
      system "./configure", "--prefix=#{iconvd}", "--disable-debug", "--disable-dependency-tracking",
                            "--enable-static", "--disable-shared"
      system "make install"
    end
    ENV.gcc_4_2

    ENV['LDFLAGS'] += " #{iconvd}/lib/libiconv.a"

    args = [ "--prefix=#{prefix}",
            "--disable-debug",
            "--enable-shared",
            "--with-iconv-dir=#{iconvd}"]

    system "./configure", *args
    system "make"
    system "make install"
  end
end
