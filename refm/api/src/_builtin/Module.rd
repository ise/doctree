= class Module < Object

モジュールのクラスです。

== Class Methods

--- constants

このメソッドを呼び出した時点で参照可能な定数名の配列を返します。

例:

  class C
    FOO = 1
  end
  p Module.constants   # => ["RUBY_PLATFORM", "STDIN", ..., "C", ...]
                       # 出力中に "FOO" は現われない

[[m:Module#constants]] や、
[[m:Kernel#local_variables]],
[[m:Kernel#global_variables]],
[[m:Object#instance_variables]],
[[m:Module#class_variables]]
も参照してください。

--- nesting

このメソッドを呼び出した時点でのクラス/モジュールのネスト情
報を配列に入れて返します。

例:

  module Foo
    module Bar
      module Baz
        p Module.nesting   # => [Foo::Bar::Baz, Foo::Bar, Foo]
      end
    end
  end

--- new
#@since 1.8.0
--- new {|mod| ... }
#@end

名前の付いていないモジュールを新しく生成して返します。

#@since 1.8.0
ブロックが与えられると生成したモジュールをブロックの引数に渡し、
モジュールのコンテキストでブロックを実行します。

  mod = Module.new
  mod.module_eval {|m| ... }
  mod

と同じです。
ブロックの実行は Module#initialize が行います。

ブロックを与えた場合も生成したモジュールを返します。
#@end

このメソッドで生成されたモジュールは、
最初に名前が必要になったときに名前が決定します。
モジュールの名前は、
そのモジュールが代入されている定数名のいずれかです。

例:

  m = Module.new
  p m               # => #<Module 0lx40198a54>
#@since 1.9.0
  p m.name          # => nil   # まだ名前は未定
#@else
  p m.name          # => ""    # まだ名前は未定
#@end
  Foo = m
  # m.name          # ここで m.name を呼べば m の名前は "Foo" に確定する
  Bar = m
  m.name            # "Foo" か "Bar" のどちらかに決まる

== Instance Methods

--- <=>(other)

self と other を比較して、
self が other の子孫であるとき -1、
同一のクラス／モジュールのとき 0、
self が other の先祖であるとき 1
を返します。

親子関係にないクラス同士の比較では
#@since 1.8.0
nil を返します。
#@else
その動作は不定です。
#@end

other がクラスやモジュールでなければ
#@since 1.8.0
nil を返します。
#@else
例外 [[c:TypeError]] が発生します。
#@end

例:

  module Foo
  end
  class Bar
    include Foo
  end
  class Baz < Bar
  end
  class Qux
  end
  p Bar <=> Foo     # => -1
  p Baz <=> Bar     # => -1
  p Baz <=> Foo     # => -1
#@since 1.8.0
  p Baz <=> Qux     # => -1
  p Qux <=> Baz     # => -1
#@end
#@since 1.8.0
  p Baz <=> Qux     # => nil
  p Qux <=> Baz     # => nil
#@else
  p Baz <=> Qux     # => 1
  p Qux <=> Baz     # => 1
#@end

#@since 1.8.0
  p Baz <=> Object.new  # => nil
#@else
  p Baz <=> Object.new  # => :in `<=>': <=> requires Class or Module (Object given) (TypeError)
#@end

--- <(other)
--- <=(other)
--- >(other)
--- >=(other)

比較演算子。self が other の子孫である時、
self < other が成立します。

親子関係にないクラス同士の比較ではいずれの関係も
#@since 1.8.0
nil を返します。
#@else
false を返します。
#@end

other がクラスやモジュールでなければ例外 [[c:TypeError]] が
発生します。

例:

  module Foo
  end
  class Bar
    include Foo
  end
  class Baz < Bar
  end
  class Qux
  end
  p Bar < Foo     # => true
  p Baz < Bar     # => true
  p Baz < Foo     # => true
#@since 1.8.0
  p Baz < Qux     # => nil
  p Baz > Qux     # => nil
#@else
  p Baz < Qux     # => false
  p Baz > Qux     # => false
#@end

  p Foo < Object.new # => in `<': compared with non class/module (TypeError)

--- ===(obj)

このメソッドは主に [[unknown:制御構造/case]] 文での比較に用いられます。
obj が self と [[m:Object#kind_of?]]
の関係がある時、真になります。つまり、[[unknown:制御構造/case]] ではクラ
ス、モジュールの所属関係をチェックすることになります。

例:

  str = String.new
  case str
  when String     # String === str を評価する
    p true        # => true
  end

--- ancestors

クラス、モジュールのスーパークラスとインクルードしているモジュール
を優先順位順に配列に格納して返します。

例:

  module Foo
  end
  class Bar
    include Foo
  end
  class Baz < Bar
    p ancestors
    p included_modules
    p superclass
  end
  # => [Baz, Bar, Foo, Object, Kernel]
  # => [Foo, Kernel]
  # => Bar

#@since 1.8.0
--- autoload(const_name, feature)
--- autoload?(const_name)

[[m:Kernel#autoload]] を参照。
#@end

--- class_eval(src[,fname[,lineno]])
--- class_eval { ... }

[[m:Module#module_eval]] の別名。

--- class_variables

クラス／モジュールに定義されている[[unknown:変数と定数/クラス変数]]名の配
列を返します。スーパークラスやインクルードしているモジュールのクラ
ス変数も含みます。

[[m:Module.constants]],
[[m:Kernel#local_variables]],
[[m:Kernel#global_variables]],
[[m:Object#instance_variables]],
[[m:Module#constants]]
も参照してください。

#@since 1.9.0
--- const_defined?(name, inherit = true)
#@else
--- const_defined?(name)
#@end

モジュールに name で指定される名前の定数が定義されている時真
を返します。name は [[c:Symbol]] か文字列で指定します。

スーパークラスやインクルードしたモジュールで定義された定数は対象には
なりません。(ただし、[[c:Object]] だけは例外
#@# あらい 2002-04-10: バグ?制限?

例:

  module Kernel
    FOO = 1
  end

  # Object は include したモジュールの定数に対しても
  # true を返す
  p Object.const_defined?(:FOO)   # => true

  module Bar
    BAR = 1
  end
  class Object
    include Bar
  end
  # ユーザ定義のモジュールに対しても同様
  p Object.const_defined?(:BAR)   # => true

  class Baz
    include Bar
  end
  # Object以外では自身の定数だけがチェック対象
  p Baz.const_defined?(:BAR)      # => false

#@since 1.9.0
--- const_get(name, inherit = true)
#@else
--- const_get(name)
#@end

モジュールに定義されている name で指定される名前の定数の値を
取り出します。定数が定義されていない時には例外 [[c:NameError]] が
発生します。
name は [[c:Symbol]] か文字列で指定します。

#@since 1.8.0
--- const_missing(name)

定義されていない定数を参照したときに Ruby がこのメソッドを呼び
ます。参照した定数名の [[c:Symbol]] が引数に渡されます。

デフォルトではこのメソッドは例外 [[c:NameError]] を発生させます。

例:

  class Foo
    def Foo.const_missing(id)
      warn "undefined constant #{id.inspect}"
    end

    Bar
  end
  Foo::Bar

  # => undefined constant :Bar
       undefined constant :Bar
#@end

--- const_set(name, value)

モジュールに name で指定された名前の定数を value とい
う値として定義し、value を返します。
そのモジュールにおいてすでにその名前の定数が定義されている場合、警
告メッセージが出力されます。name は [[c:Symbol]] か文字列で
指定します。

#@since 1.9.0
--- constants(inherit = true)
#@else
--- constants
#@end

そのモジュール(またはクラス)で定義されている定数名の配列を返
します。
スーパークラスやインクルードしているモジュールの定数も含みます。

[[m:Module.constants]] や
[[m:Kernel#local_variables]],
[[m:Kernel#global_variables]],
[[m:Object#instance_variables]],
[[m:Module#class_variables]]
も参照してください。


例: Module.constants と Module#constants の違い

  # 出力の簡略化のため起動時の定数一覧を取得して後で差し引く
  $clist = Module.constants

  class Foo
    FOO = 1
  end
  class Bar
    BAR = 1

    # Bar は BAR を含む
    p constants - $clist                # => ["BAR"]
    # 出力に FOO は含まれない
    p Module.constants - $clist         # => ["BAR", "Bar", "Foo"]
    class Baz
      # Baz は定数を含まない
      p constants - $clist              # => []

      # ネストしたクラスでは、外側のクラスで定義した定数は
      # 参照可能なので、BAR は、Module.constants には含まれる
      # (クラス Baz も Bar の定数なので同様)
      p Module.constants - $clist       # => ["BAR", "Baz", "Bar", "Foo"]
    end
  end

#@since 1.8.0
--- include?(mod)

self かその親クラス / 親モジュールがモジュール mod を
インクルードしていれば true を返します。

例:

  module M
  end
  class C1
    include M
  end
  class C2 < C1
  end

  p C1.include?(M)   # => true
  p C2.include?(M)   # => true
#@end

--- included_modules

インクルードされているモジュールの配列を返します。
[[m:Module#ancestors]] の例も参照してください

--- instance_method(name)

self のインスタンスメソッドをオブジェクト化した
[[c:UnboundMethod]] を返します。
name は [[c:Symbol]] か文字列です。

[[m:Object#method]] も参照してください。

#@since 1.9.0
--- method_defined?(name, inherit = true)
#@else
--- method_defined?(name)
#@end

モジュールにインスタンスメソッド name が定義されているとき
true を返します。name は [[c:Symbol]] か文字列です。

[[m:Module#public_method_defined?]],
[[m:Module#private_method_defined?]],
[[m:Module#protected_method_defined?]]
も参照してください。

--- module_eval(expr, [fname, [lineno=1]])
--- module_eval {|mod| .... }

モジュールのコンテキストで文字列 expr を評価して
その結果を返します。
fname、lineno が与えられた場合は、ファイル fname、
行番号 lineno にその文字列があるかのようにコンパイルされ、
スタックトレース表示などの
ファイル名／行番号を差し替えることができます。

ブロックが与えられた場合にはそのブロックを
モジュールのコンテキストで評価してその結果を返します。
ブロックの引数 mod には self が渡されます。

モジュールのコンテキストで評価するとは、
実行中そのモジュールが self になるということです。
つまり、そのモジュールの定義文の中にあるかのように
実行されます。

ただし、ローカル変数は module_eval の外側のスコープと共有します。

ブロックが与えられた場合は、
定数とクラス変数のスコープも外側のスコープになります。

注:
module_eval のブロック中でメソッドを定義する場合、
[[m:Object#instance_eval]] と同様の制限があります。
詳細はそちらの説明を参照してください。

[[m:Object#instance_eval]],
[[m:Module#class_eval]]
[[m:Module.new]] も参照してください。

--- name
--- to_s

モジュールやクラスの名前を文字列で返します。
#@since 1.9.0
名前のないモジュール / クラスに対しては nil を返します。
#@else
名前のないモジュール / クラスに対しては空文字列を返します。
#@end

このメソッドが返す「モジュール / クラスの名前」とは、
より正確には「クラスパス」を指します。
クラスパスとは、ネストしているモジュールすべてを
「::」を使って表示した名前のことです。
クラスパスの例としては「CGI::Session」「Net::HTTP」が挙げられます。

例:

  module A
    module B
    end

    p B.name  #=> "A::B"
 
    class C
    end
  end

  p A.name    #=> "A"
  p A::B.name #=> "A::B"
  p A::C.name #=> "A::C"

  # 名前のないモジュール / クラス
#@since 1.9.0
  p Module.new.name   #=> nil
  p Class.new.name    #=> nil
#@else
  p Module.new.name   #=> ""
  p Class.new.name    #=> ""
#@end

--- instance_methods([inherited_too])
--- public_instance_methods([inherited_too])
--- private_instance_methods([inherited_too])
--- protected_instance_methods([inherited_too])

そのモジュールで定義されている public/private/protected メソッド名
の一覧を配列で返します。

instance_methods は、public_instance_methods と同じです。
#@since 1.8.0
instance_methods は、public および
protected メソッド名の一覧を配列で返します。
#@end

inherited_too が真であれば、スーパークラスのメソッドも探索し
ます。デフォルトは偽です。
#@since 1.8.0
引数のデフォルトは真に変わる予定です。
引数を省略すると警告が出るので、変更までは引数を明示することが望ま
れます)
#@end

[[m:Object#methods]],
[[m:Object#public_methods]],
[[m:Object#private_methods]],
[[m:Object#protected_methods]]
も参照してください。

例1:

  class Foo
    private;   def private_foo()   end
    protected; def protected_foo() end
    public;    def public_foo()    end
  end

  # あるクラスのインスタンスメソッドの一覧を得る
  p Foo.instance_methods(false)
  p Foo.public_instance_methods(false)
  p Foo.private_instance_methods(false)
  p Foo.protected_instance_methods(false)

  class Bar < Foo
  end

実行結果

#@since 1.8.0
     ["protected_foo", "public_foo"]
#@else
     ["public_foo"]
#@end
     ["public_foo"]
     ["private_foo"]
     ["protected_foo"]

例2:

  # あるクラスのインスタンスメソッドの一覧を得る。
  # 親のクラスのインスタンスメソッドも含めるため true を指定して
  # いるが、Object のインスタンスメソッドは一覧から排除している。
  p Bar.instance_methods(true)           - Object.instance_methods(true)
  p Bar.public_instance_methods(true)    - Object.public_instance_methods(true)
  p Bar.private_instance_methods(true)   - Object.private_instance_methods(true)
  p Bar.protected_instance_methods(true) - Object.protected_instance_methods(true)

実行結果

#@since 1.8.0
     ["protected_foo", "public_foo"]
#@else
     ["protected_foo"]
#@end
     ["public_foo"]
     ["private_foo"]
     ["protected_foo"]

--- private_class_method(name, ...)

name で指定したクラスメソッド (クラスの特異メソッド) の
可視性を private に変更します。

self を返します。

--- public_class_method(name, ...)

name で指定したクラスメソッド (クラスの特異メソッド) の
可視性を public に変更します。

self を返します。

#@since 1.8.0
--- private_method_defined?(name)

インスタンスメソッド name がモジュールに定義されており、
しかもその可視性が private であるときに true を返します。
そうでなければ false を返します。

name は [[c:Symbol]] か文字列です。

[[m:Module#method_defined?]] も参照してください。

--- protected_method_defined?(name)

インスタンスメソッド name がモジュールに定義されており、
しかもその可視性が protected であるときに true を返します。
そうでなければ false を返します。

name は [[c:Symbol]] か文字列です。

[[m:Module#method_defined?]] も参照してください。

--- public_method_defined?(name)

インスタンスメソッド name がモジュールに定義されており、
しかもその可視性が public であるときに true を返します。
そうでなければ false を返します。

name は [[c:Symbol]] か文字列です。

[[m:Module#method_defined?]] も参照してください。
#@end

#@since 1.8.6
--- class_variable_defined?(symbol)
#@# => true or false

Returns true if the given class variable is defined in obj.

   class Fred
     @@foo = 99
   end
   Fred.class_variable_defined?(:@@foo)    #=> true
   Fred.class_variable_defined?(:@@bar)    #=> false

#@end

== Private Instance Methods

--- alias_method(new, old)

メソッドの別名を定義します。
[[unknown:クラス／メソッドの定義/alias]] との違いは以下の通りです。

  * メソッド名は文字列または [[c:Symbol]] で指定する
  * グローバル変数の別名をつけることはできない
#@since 1.7.3
#@#see [ruby-dev:17894]
  * alias は構文なのでメソッドの中では使えない
#@end

self を返します。

--- append_features(module_or_class)

モジュール(あるいはクラス)に self の機能を追加します。
このメソッドは Module#include の実体であり、
include を Ruby で書くと以下のように定義できます。
#@# あらい 2002-03-03: Ruby 1.8 では include を実行する
#@# 順序が変わったので each の代わりに reverse_each を使う

  def include(*modules)
    modules.each {|mod|
      # append_features はプライベートメソッドなので
      # 直接 mod.append_features(self) とは書けない
#@since 1.9.0
      mod.__send!(:append_features, self)
      mod.__send!(:included, self)
#@else
      mod.__send__(:append_features, self)
#@since 1.8.0
      mod.__send__(:included, self)
#@end
#@end
    }
  end

self を返します。

--- attr(name[, assignable])

属性読み込みのためのインスタンスメソッド name を定義します。
name は [[c:Symbol]] か文字列で指定します。戻り値は常に
nil です。

このメソッドで定義されるアクセスメソッドの定義は次の通りです。

  def name
    @name
  end

省略可能な第 2 引数 assignable が指定されその値が真である
場合には、属性の書きこみ用メソッド name= も同時に定義されます。
その定義は次の通りです。

  def name=(val)
    @name = val
  end

--- attr_accessor(name, ...)

属性 name に対する読み込みメソッドと書きこみメソッドの両方を
定義します。name は [[c:Symbol]] か文字列で指定します。戻り値
は常に nil です。

このメソッドで定義されるメソッドの定義は以下の通りです。

  def name
    @name
  end
  def name=(val)
    @name = val
  end

--- attr_reader(name, ...)

属性 name の読み出しメソッドを定義します。
name は [[c:Symbol]] か文字列で指定します。
戻り値は常に nil です。

このメソッドで定義されるメソッドの定義は以下の通りです。

  def name
    @name
  end

--- attr_writer(name, ...)

属性 name への書き込みメソッド (name=) を定義します。
name は [[c:Symbol]] か文字列で指定します。戻り値は常に
nil です。

このメソッドで定義されるメソッドの定義は以下の通りです。

  def name=(val)
    @name = val
  end

#@since 1.8.3
--- class_variable_get(name)

クラス／モジュールに定義されているクラス変数 name の値を返します。

name は [[c:Symbol]] か文字列で指定します。

クラス変数 name が定義されていない場合、例外 [[c:NameError]]
が発生します。

例:

  class Fred
    @@foo = 99
  end

  def Fred.foo
    class_variable_get(:@@foo)
  end

  p Fred.foo #=> 99
#@end

#@since 1.8.3
--- class_variable_set(name, val)

クラス／モジュールにクラス変数 name を定義して、その値として
val をセットします。val を返します。

name は [[c:Symbol]] か文字列で指定します。

例:

  class Fred
    @@foo = 99
    def foo
      @@foo
    end
  end

  def Fred.foo(val)
    class_variable_set(:@@foo, val)
  end

  p Fred.foo(101)   # => 101
  p Fred.new.foo    # => 101
#@end

--- define_method(name, method)
--- define_method(name) { ... }

インスタンスメソッド name を定義します。
method には [[c:Proc]]、[[c:Method]] あるいは
[[c:UnboundMethod]] のいずれかのインスタンスを指定します。
引数 method を与えたときはそれを、ブロック付きで
呼びだしたときはブロックを [[c:Proc]] 化したオブジェクトを、
それぞれ返します。

例:

  class Foo
    def foo() p :foo end
    define_method(:bar, instance_method(:foo))
  end
  Foo.new.bar    # => :foo

ブロックを与えた場合、Ruby 1.7 以降では、定義したメソッド
の実行時にブロックがレシーバクラスのインスタンスの上で
instance_eval されます。
一方 Ruby 1.6 ではブロックとメソッドの関連づけを行うだけで、
メソッドの実行時にはブロックは生成時のコンテキストのままで
実行されます。たとえば以下の例を参照してください。

  class C
    def print_self
      p get_self
    end
  end
  # インスタンスメソッド get_self を定義。
  # ただし define_method はプライベートメソッド
  # なので直接は呼べない。__send__ を介して呼ぶ。
  C.__send__(:define_method, :get_self) { self }

  # 1.6 の場合
  C.new.print_self    #=> main
  # 1.7 の場合
  C.new.print_self    #=> #<C:0x4015b490>

--- extend_object(object)

[[m:Object#extend]] の実体です。オブジェクトに
モジュールの機能を追加します。Object#extend は、Ruby で
書くと以下のように定義できます。
#@# あらい 2002-03-16: ((<ruby 1.7 feature>)) では、extend を実行する
#@# 順序が変わったので each の代わりに reverse_each を使う

  def extend(*modules)
    modules.each {|mod| mod.__send__ :extend_object, self }
  end

extend_object のデフォルトの実装では、self に定義されて
いるメソッドを object の特異メソッドとして追加します。

object を返します。

#@since 1.8.0
--- extended(class_or_module)

self が他のオブジェクト に [[m:Object#extend]] されたときに
呼ばれます。引数には extend を行ったオブジェクトが渡されます。


例:

  module Foo
    def self.extended(mod)
      p "#{mod} extend #{self}"
    end
  end

  Object.new.extend Foo

  # => "#<Object:0x401cbc3c> extend Foo"
#@end

--- include(mod, ...)

モジュール mod をインクルードします。
self を返します。

インクルードとは、指定されたモジュールの定義
#@since 1.9.0
(メソッドや定数) を引き継ぐことです。
#@else
(メソッドや定数、クラス変数) を引き継ぐことです。
#@end
インクルードは多重継承の代わりに用いられており、
mix-in とも呼びます。

例:

  class C
    include FileTest
    include Math
  end

  p C.ancestors

  # => [C, Math, FileTest, Object, Kernel]

モジュールの機能追加は、クラスの継承関係の間にそのモジュールが挿入
されることで実現されています。従って、メソッドの探索などは
スーパークラスよりもインクルードされたモジュールのほうが
先に行われます
(上の例の [[m:Module#ancestors]] の結果がメソッド探索の順序です)。

同じモジュールを二回以上 include すると二回目以降は無視されます。

例:

  module M
  end
  class C1
    include M
  end
  class C2 < C1
    include M   # この include は無視される
  end

  p C2.ancestors  # => [C2, C1, M, Object, Kernel]

モジュールの継承関係が循環してしまうような include を行うと、
例外 [[c:ArgumentError]] が発生します。

例:

  module M
  end
  module M2
    include M
  end
  module M
    include M2
  end

実行結果:

  -:3:in `append_features': cyclic include detected (ArgumentError)
          from -:3:in `include'
          from -:3

#@since 1.8.0
引数に複数のモジュールを指定した場合、
最後の引数から順にインクルードします。
#@end

#@since 1.8.0
--- included(class_or_module)

self が include されたときに対象のクラスまたはモジュー
ルを引数にインタプリタから呼び出されます。

例:

  module Foo
    def self.included(mod)
      p "#{mod} include #{self}"
    end
  end
  class Bar
    include Foo
  end
  # => "Bar include Foo"
#@end

--- method_added(name)

メソッド name が追加された時にインタプリタから呼び出されます。
name には追加されたメソッドの名前が [[c:Symbol]] で渡されます。

例:

  class Foo
    def Foo.method_added(name)
      puts "method \"#{name}\" was added"
    end

    def foo
    end
    define_method :bar, instance_method(:foo)
  end

  => method "foo" was added
     method "bar" was added

特異メソッドの追加に対するフックには
[[m:Object#singleton_method_added]]
を使います。

#@since 1.8.0
--- method_removed(name)

メソッドが [[m:Module#remove_method]] により削
除された時にインタプリタから呼び出されます。
name には削除されたメソッド名が [[c:Symbol]] で渡されます。

例:

  class Foo
    def Foo.method_removed(name)
      puts "method \"#{name}\" was removed"
    end

    def foo
    end
    remove_method :foo
  end

  => method "foo" was removed

特異メソッドの削除に対するフックには
[[m:Object#singleton_method_removed]]
を使います。
#@end

#@since 1.8.0
--- method_undefined(name)

このモジュールのインスタンスメソッド name が
[[m:Module#undef_method]] によって削除されるか、
undef 文により未定義にされると、
Ruby 処理系がこのメソッドを呼び出します。
name は [[c:Symbol]] オブジェクトです。

例:

  class C
    def C.method_undefined(name)
      puts "method C\##{name} was undefined"
    end

    def foo
    end
    def bar
    end

    undef_method :foo
    undef bar
  end

実行結果:

  method C#foo was undefined
  method C#bar was undefined

特異メソッドの削除をフックするには
[[m:Object#singleton_method_undefined]]
を使います。
#@end

--- module_function([name, ...])

引数が与えられた時には、
引数で指定されたメソッドをモジュール関数にします。
引数なしのときは今後このモジュール定義文内で
新しく定義されるメソッドをすべてモジュール関数にします。

モジュール関数とは、プライベートメソッドであると同時に
モジュールの特異メソッドでもあるようなメソッドです。
例えば [[c:Math]] モジュールのメソッドはすべてモジュール関数です。

self を返します。

[注意]
module_function はメソッドに「モジュール関数」という属性をつけるメ
ソッドではなく、プライベートメソッドとモジュールの特異メソッドの 2
つを同時に定義するメソッドです。
そのため、以下のように書いてもモジュール関数の別名は定義できません。

  module M
    def foo
      p "foo"
    end
    module_function :foo
    alias bar foo
  end

  M.foo   # => "foo"
  M.bar   # => undefined method `bar' for Foo:Module (NoMethodError)

このコードでは、モジュール関数 foo と
プライベートインスタンスメソッド bar を定義してしまいます。

正しくモジュール関数に別名を付けるには、
以下のように、先に別名を定義してから
それぞれをモジュール関数にしなければいけません。

  module M
    def foo
      p "foo"
    end

    alias bar foo
    module_function :foo, :bar
  end

  M.foo   # => "foo"
  M.bar   # => "foo"

--- private([name, ...])

引数なしのときは今後このクラスまたはモジュール定義内で新規に定義さ
れるメソッドを関数形式でだけ呼び出せるように(private)設定します。

引数が与えられた時には引数によって指定されたメソッドを private に
設定します。

例:

  class Foo
    def foo1() 1 end      # デフォルトでは public
    private               # 可視性を private に変更
    def foo2() 2 end      # foo2 は private メソッド
  end

  foo = Foo.new
  p foo.foo1          # => 1
  p foo.foo2          # => private method `foo2' called for #<Foo:0x401b7628> (NoMethodError)

self を返します。

--- protected([name, ...])

引数なしのときは今後このクラスまたはモジュール定義内で新規に定義さ
れるメソッドを protected に設定します。protected とはそのメソッド
が定義されているクラスまたはそのサブクラスからしか呼び出すことがで
きないという意味です。

引数が与えられた時には引数によって指定されたメソッドを protected
に設定します。

self を返します。

--- public([name, ...])

なしのときは今後このクラスまたはモジュール定義内で新規に定義さ
れるメソッドをどんな形式でも呼び出せるように(public)設定します。

引数が与えられた時には引数によって指定されたメソッドを public に設
定します。

例:

  def foo() 1 end
  p foo             # => 1
  # the toplevel default is private
  p self.foo        # => private method `foo' called for #<Object:0x401c83b0> (NoMethodError)

  def bar() 2 end
  public :bar       # visibility changed (all access allowed)
  p bar             # => 2
  p self.bar        # => 2

self を返します。

--- remove_class_variable(name)

で指定したクラス変数を取り除き、そのクラス変数に設定さ
れていた値を返します。もし指定したクラス変数がそのモジュール(また
はクラス)で定義されていない場合は例外 [[c:NameError]] が発生します。

例:

  class Foo
    @@foo = 1
    remove_class_variable(:@@foo)   # => 1
    p @@foo   # => uninitialized class variable @@foo in Foo (NameError)
  end

[[m:Module#remove_const]],
[[m:Object#remove_instance_variable]]
も参照してください。

--- remove_const(name)

name で指定した定数を取り除き、その定数に設定されていた値を
返します。指定した定数がそのモジュール(またはクラス)で定義されてい
ない場合は例外 [[c:NameError]] が発生します。

例:

  class Foo
    FOO = 1
    p remove_const(:FOO)    # => 1
    p FOO     # => uninitialized constant FOO at Foo (NameError)
  end

現在のところ組み込みクラス/モジュールを設定している定数や
[[m:Kernel#autoload]] を指定した(まだロードしてない)定数を削除
できないという制約があります。

例:

  class Object
    remove_const :Array
  end
  => -:2:in `remove_const': cannot remove Object::Array (NameError)

[[m:Module#remove_class_variable]],
[[m:Object#remove_instance_variable]]
も参照してください。

#@since 1.8.0
--- remove_method(name[, name2, ...])
#@else
--- remove_method(name)
#@end

インスタンスメソッド name をモジュールから削除します。
指定したメソッドが定義されていないときには
例外 [[c:NameError]] が発生します。

例:

  class C
    def foo
    end

    remove_method :foo
    remove_method :no_such_method   # 例外 NameError が発生
  end

#@since 1.8.0
Ruby 1.8.0 以降は複数のメソッド名を指定して一度に削除できます。
#@end

self を返します。

[[m:Module#undef_method]] の例も参照してください。

#@since 1.8.0
--- undef_method(name[, name2, ...])
#@else
--- undef_method(name)
#@end

このモジュールのインスタンスメソッド name, name2, ... を未定義にします。
指定したインスタンスメソッドが定義されていないときは
例外 [[c:NameError]] が発生します。

「未定義にする」とは、
このモジュールのインスタンスに対して name という
メソッドを呼び出すことを禁止するということです。
スーパークラスの定義が継承されるかどうかという点において、
「未定義」は「メソッドの削除」とは区別されます。
以下のコード例を参照してください。

  class A
    def ok
      puts 'A'
    end
  end
  class B < A
    def ok
      puts 'B'
    end
  end

  B.new.ok   # => B

  # undef_method の場合はスーパークラスに同名のメソッドがあっても
  # その呼び出しはエラーになる
  class B
    undef_method :ok
  end
  B.new.ok   # => NameError

  # remove_method の場合はスーパークラスに同名のメソッドがあると
  # それが呼ばれる
  class B
    remove_method :ok
  end
  B.new.ok   # => A

#@since 1.8.0
#@#see [ruby-dev:17894]
また、undef 文と undef_method の違いは、
メソッド名を文字列または [[c:Symbol]] で与えられることです。
#@else
また、undef 文と undef_method の違いは、
メソッド名を文字列または [[c:Symbol]] で与えられること、
メソッド内でも使用できることです。
#@end

self を返します。
