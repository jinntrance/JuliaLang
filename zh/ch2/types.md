# 类型

Julia 类型系统首屈一指。Julia 多数时间像Python 一样是动态类型的。例如一个变量先前是赋值整型，后来可以赋值浮点型。如后：

```julia
julia> x = 10
10
julia> x = "hello"
"hello"
```
然而，也可选择把类型定义加到变量声明的地方；如此此变量就只可被重新赋值为同类型的值。譬如，声明`x::ASCIIString` 就是说只能将字符串赋值给x；一般形式就是`var::TypeName`。这种显示声明，通常也被用着限制函数参数的具体类型。并且额外的类型信息，可当作注释，也可让即时编译器产生优化得更好的机器码；并且这样也能让开发环境提供更好的支持，譬如代码工具中也可以检查代码是否存在类型错误。

如后便是一个简单的例子：`calc_position(time::Float64)` 表示该函数只接受Float64 类型的参数。

Julia 使用同样的语法，用于检查变量或表达式的确切类型。譬如当`(expr)::TypeName` 中的expr 类型与后面TypeName 不匹配时便会抛错。例如：

```julia
julia> (2+3)::ASCIIString
ERROR: type: typeassert: expected ASCIIString, got Int64
```
得特别注意的是，跟大多数其他语言不一样，Julia 类型是标在变量名后的。一般情况下，Julia 变量的类型是可改的，但却对性能不利。为了性能最佳，还是使用固定类型为妙。若每一个变量的类型不随时间变化，整个代码段的类型是也就是稳定的。对变量的类型的深入思考，也能帮助我们有效避免性能瓶颈。在循环的关键部分加入待更新的变量的类型说明，可让JIT编译器除去一些类型检查，从而大幅度提升性能。此问题一个很好的例文见[此文](http://www.johnmyleswhite.com/notebook/2013/12/06/writing-type-stable-code-in-julia/) 。

Julia 中很多类型都存在，实际上，是以层次结构树形存在的。如果没有指定函数参数的类型，那么类型就是`Any` ，这实际上是所有类型的根或父类型。每个对象至少是通用类型`Any` 。另在对立的另一面，`None` 类型，没有对象可以有这种类型，但它是所有其他类型的子类型。执行代码的时候，Julia 将推断传递给函数的参数的类型，并使用此信息，这将产生最佳的机器代码。

当然用户也可以定义自定义类型，例如，`Person` 类型。按照惯例，类型名称以大写字母开头，不同的词拼接后续词首字母大写，如`BigFloat` 或`AbstractArray` 。

如果x 是变量，然后`typeof(x)` 便获得其类型；`isa(x,T)` 测试x是否是T 类型这个俩性。例如 ，`isa("ABC",String)` 为true ，`isa(1, Bool)` 为false 。

Julia 中任何元素都有类型，包括类型自己也有自己的类型`DataType`。如`typeof(Int64)` 返回的是DataType 。强制类型转化，可以使用类型名对应的小写名函数，例如 ，`int64(3.14) == 3`

然而，这会在类型不可转换时报错：

```julia
julia> int64("hello")
ERROR: invalid base 10 digit 'h' in "hello"
```
## 整型

Julia 支持从 Int8 到Int128 的整型。其数据存储也对应8〜128 bit。无符号整型只需对应加上`U` 前缀，如 UIint8 。默认整型类型（也可使用Int 表示）是Int32 或Int64 类型，因目标机器体系结构而变。位宽由变量`WORD_SIZE` 给出。整数所使用的位数决定了其最大和最小值。最小和最大值分别由`typemin()` 和`typemax()` 两个函数给出，例如`typemax(Int16)` 返回32767。

若存储超过typemax 范围的数，就会溢出。例如：

```julia
julia> typemax(Int64)
9223372036854775807
julia> typemax(Int64) + 1
-9223372036854775808
``` 

溢出检查是不是Julia 自动完成的，所以对这种情况的显式检验（例如，结果符号出错）时是必要的。整数还可以写成二进制（0b）， 八进制（0o），和十六进制（0x）格式。

对于任意精度的计算，Julia 有一个`BigInt` 类型。此类型可通过`BigInt("number")` 构造，并支持跟其他整型相同的操作。数值类型之间的转换是自动的，但基本类型和`Big*` 类型却不是。另外，正常的加（+）、 减（ - ）、乘 （*）应用于整数。而除法（/）总返回浮点数。如果只想得到整数除数与余数，使用`div` 和`rem` 即可。符号`^`用于获取一个数的幂。逻辑值， Bool 类型的true/false ，也是8 位的整数。0代表false，1（及其他非0值）代表true。例如，`bool(-56) == true`。逻辑否可用做`!` 这个操作符。比较可使用`==` `!=` `<` `>` ，且可链式使用如`0< x <3`。

## 浮点数

浮点数遵循IEEE 754标准，使用小数点或科学计数法，如 3.14 或4E-14，并且类型支持从`Float16` 到`Float64`，后者也是双精度类型。单精度通过`Float32`。单精度浮点数必须用科学记数法，如`3.14f0`。这里指数使用`f`，跟通常使用的`e` 不同。也就是说，`2.5f2` 表示单精度的 $$ 2.5 * 10 ^ 2$$ ，而 `2.5e2` 表示双精度的 $$2.5 * 10 ^ 2$$ 。Julia 也有 BigFloat 类型对任意精度的浮点数计算提供支持。

内置的类型系统负责所有的数字类型无缝地相互操作，因此用户不需要显示地转换。浮点数特殊值包含：`Inf` `-Inf` 两个正负无穷大，以及非数字 `NaN`(Not a number)。比如`NnN`就可能是 `0/0` 或 `Inf - Inf` 的结果。

所有编程语言里，浮点运算通常导致微妙的错误和违反直觉的结果。例如：

```julia
julia> 0.1 + 0.2
0.30000000000000004
```  

会发生这种情况，是因为浮点数在计算机内部存储的方式。大多数数字不能使用有限的数位存储，例如十进制的`1/3` 不能通过有限数位表示。计算机会选择可以代表此数的最接近的数，从而引入小的**舍入误差** 。这些误差可能会在较长计算过程中累积，从而产生微妙的问题。

这最大的影响就是，比较浮点数时切忌使用等号：

```julia
julia> 0.1 + 0.2 == 0.3
false
```

更好的解决方案是，涉及浮点数比较时，尽可能布尔测试的 `>=` 或 `<=` 取定范围比较。

### 基础数学函数和操作

可以看到的任何数（整数或浮点数）的二进制表示，例如， `bits(3)` 返回“0000000000000000000000000000000000000000000000000000000000000011”。

对一个数四舍五入，使用 `round()` 或 `iround()` 函数：前者返回浮点数，后者返回一个整数。所有标准的数学函数都用提供，如 sqrt(), cbrt(), exp(), log(), sin(), cos(), tan(), erf()（误差函数），及更多（请参考以下网址）。要生成一个随机数，使用 rand()。

用括号`()` 左右表达式来强制指定优先级。链式赋值是允许的如 `a = b = c = d = 1` 。赋值过程是从右往左的。赋值不同的变量也可以结合起来，例如：

```julia
a= 1; b = 2; c = 3; d = 4
a, b = c, d # a为3, b为4
```

交换两个数也特别简单：

```julia
a, b = b,a ＃现在a为4和b为3  
```

像在其他语言中一样，布尔运算`&&` `||` 和`!` 来进行与、或、非操作。Julia 也采用短路优化，意即：

- `a && b` 中，a 若为false 则b 不被计算
- `a || b` 中，a 若为true 则b 不被计算

而操作符号`&` `|` ，也可用于逻辑判断，但不作短路优化。

Julia 还支持整数的位运算。其中 ，整数n 在Julia 不存在如后的操作：`n++` 或 `n--`；虽然在C++ 或Java 可如此使用，但Julia 使用 `n += 1` 或 `n -= 1` 来代替。

有关操作的更详细的信息，如位运算，特殊优先级等等，参见[Julia 数学运算](http://docs.julialang.org/en/latest/manual/mathematical-operations/)。

## 分数和复数

Julia 中这些类型开箱即用。全局常量`im`表示-1的平方根 ，所以`3.2+7.1im` 是浮点数的复数，它的的类型 是`Complex{Float64}`。

这是Julia 中一个*参数类型* [^PT]的​​首例。此例中，我们可写成`Complex{T}`，如此类型T便可取不同的的Int32 或 Int64类型。

所有操作和基本函数（例如exp(), sqrt(), sinh(), real(), imag(), abs() 等）对复数也是适用的；例如，`abs(3.2+7.1im)= 7.787810988975015`。

如果 a和b是两个数值变量，使用`complex(a,b)`则可构建复数。当你想使用确切的比例时，分数就排上用场了，例如，`3 // 4`， 它的类型是`Rational{Int64}`。同样的，比较和标准操作对分数也适用： `float()` 将其转换为浮点数， 和`num()`和`denum()` 取出其分子和分母。这两种类型都能与其他数值类型无缝地结合使用。

## 字符

如C或Java，但不同于Python中，Julia 单字符的类型`Char`。被写为`'A'`的 字符，调用`typeof('A')` 就得到`Char`。`Char` 类型 ，实际上是一个32位整数，其数值是Unicode 码值转写，范围从 `'\0'`到`'\Uffffffff'`。转换字符成其码值是可用`int()`: 如`int('A')`返回65，`int(α)` 返回945，如此这个字符就需要两字节存储。

反过来也适用：`char(65)` 返回'A'，`char(945)`返回'α'。

Unicode字符可以用带有`\U`的前缀，而后4个（或8个）十六进制数字（0-9，A-F），最后用单引号引起来表示 。`is_valid_char()` 可用于测试一个数字是否能对应现有的Unicode字符 ：`is_valid_char(0x3b1)` 就返回true。正常的转义字符如 `\t`（tab），`\n`（换行），`\'` 等在Julia 中也存在。

## 字符串

文字串始终是ASCII（如果它们只包含ASCII 字符） 或 UTF8（如果它们包含非ASCII 字符）中的两种类型，如在本例中：

```
julia> typeof("hello")
ASCIIString (constructor with 2 methods)
julia> typeof("习大大")
UTF8String (constructor with 2 methods)
```

UTF16 和 UTF32 也支持的。字符串是包含在双引号`" "` 或 三引号`''' '''`中的。字符串是不可变的，意即它们一旦被就不能被改变：

```
julia> s = "Hello Julia"
"Hello Julia"
julia> s[2] = 'z'
ERROR: `setindex!` has no method matching setindex!(::ASCIIString, ::Char, ::Int64)
```

一个字符串，是有索引（索引从1 开始）的一连串字符（参见见的Range 和Arrays 章节）：若`str = "Julia"`， 则`str[1]`返回字符`'J'`，且`str[end]` 返回最后一个字符`'a'`。最后一个字节的索引，可调用`endof(str)`获得，而长度则可用`length()`函数。如果字符串包含多字节Unicode字符，那么两者结果就不一致，例如，`endof("习大大")` 给出7，而 `length("习大大")` 得到3。

使用越界索引（小于-1，或大于最后一个字符的索引值）就会报错 BoundsError。一般情况下，字符串可以包含Unicode字符（单字符可能多达四个字节），所以不是每一个索引都是合理的。例如，

```
julia> str2="我是陈欧，我为自己带盐"
"我是陈欧，我为自己带盐"
julia> str2[1]
'我'
julia> str2[2]
ERROR: invalid UTF-8 character index
julia> str2[4]
'是'
julia> endof(str2)
31
julia> length(str2)
11
```
其中`"我"`占三个字节，而字符串使用索引访问时，索引是基于字节建立的，而根据索引取出当前字节时，Julia 会通过当前字符开始的字符。并且，我们看到`endof(str2)` 得到的最末索引是31，而`length(str2)` 得到的字符长度为11。因此，取字符串的中的字符时，最好用迭代而不使用索引，如下：

```julia
for c in str2
    println(c)
end
``` 

子串可以通过指定索引范围来获得：`str[3:5]` 或`str[3:end]` 返回 "lia"。包含一个字符的字符串，跟该字符是不同的：`"A"=='A'` 返回 false。

Julia 在构建字符串时，有一个优雅的字符串插入替换机制：在字符串中的`$var`，会被`var`的确切值替换；字符串中的`$(expr)`（其中expr是 一个表达式），也会被替成表达式的结果值。当a是 2，b是3时，以下表达式 `$a * $b = $( a * b )` 返回`"2 * 3 = 6"`。如果你需要在字符串中用到`$`符号，可使用转义 `\$`。

连接字符串也可用运算符`*`或使用`string()` 函数：`"abc" * "def"` 和 `string("abc","def")` 返回的结果都是`"abcdef"`。

字符串加上前缀`:`就编程了`Symbol`类型， 如`:green` ; 我们已经在`print_with_color` 函数中用过。它们比字符串更有效，并用于ID或键（keys）。符号不能被连接起来。它们只用于程序执行过程中的常量。字符串类型定义的函数非常丰富，有354 个之多，并且可通过形如`methodswith(String)` 调用。一些有用的函数如后：

- `search(string, char)`： 返回字符串中第一个匹配上的字符的索引 ，如`search("Julia", 'l')` 返回3。
- `replace(string, str1, str2)`：将string 字符串中的str1 替换为str2，例如，`replace("Julia", "u", "o")` 返回`"Jolia"`。
- `split(string, char or [chars])`： 按照`char` 或 `chars` 分隔指定字符串string ，例如， `split(" 34, Tom Jones, Pickwick Street 10, Aberdeen", ',')`返回长度为4 的字符串数组 ：`[" 34"," Tom Jones"," Pickwick Street 10"," Aberdeen"]`; 如果没有指定分隔符，默认分隔符使用空字符（空格，制表符，换行符等）。

## 格式化数字和字符串

该`@printf` 宏（我们会在[第7章](../ch7/) *Julia 中的元编程* 深入研究宏 ）在格式化中，会用到指定格式的一个*格式字符串*，一个（或多个）待格式化的变量。它的工作原理类似于C 语言的`printf`。同时，用户可以在*格式字符串*中使用变量占位符 。例如：

```
julia> name = "Pascal"
"Pascal"
julia> @printf("Hello, %s \n", name)
Hello, Pascal 
```

如果你需要格式化后的字符串作为返回值，可使用宏`@sprintf`。

下面的脚本显示了最常见的格式（ `show`是打印对象的文本表示基本函数，往往比`print` 更具体）：

```
# d for integers: 
@printf("%d\n", 1e5) #> 100000 
x = 7.35679 # f = float format, rounded if needed:
@printf(" x = %0.3f\n", x) #> 7.357 
aa = 1.5231071779744345 
bb = 33.976886930000695 
@printf("%.2f %.2f\n", aa, bb) #> 1.52 33.98 
# or to create another string: 
str = @sprintf("%0.3f", x) 
show( str) #> "7.357" 
println() 
# e = scientific format with e: 
@printf("%0.6e\n", x) #> 7.356790e + 00 
# c = for characters: 
@printf(" output: %c\n", 'α') #> output: α 
# s for strings: 
@printf("%s\n", "I like Julia") 
# right justify: 
@printf("%50s\n", "text right justified!")
```

获得上运行上述脚本的输出如下：

```
100000
 x = 7.357
1.52 33.98
"7.357"
7.356790e+00
 output: α
I like Julia
                             text right justified!
``` 

一种特殊的字符串是形如`v"0.3.0"`（注意前面的v，及双引号中的其他详细信息） 的`VersionNumber`。这类字符串可以相互比较，它们不仅用于Julia 的版本，还用于`Pkg` 的包版本和依赖（[第1章](../ch1/)*安装Julia 环境*的包管理部分 ）。如果你需要针对不同版本定制化代码，可参照如下例子：

```
if v"0.3" < = VERSION < v"0.4-"
    # do something specific to 0.3 release series 
end
```  
  
[^PT]: Parametric type
  
  

