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

浮点数遵循IEEE 754标准，使用小数点或科学计数法，如 3.14 或4E-14，并且类型支持从`Float16` 到`Float64`，后者也是双精度类型。单精度通过`Float32`。单精度浮点数必须用科学记数法，如`3.14f0`。这里指数使用`f`，跟通常使用的`e` 不同。也就是说，`2.5f2` 表示单精度的 $ 2.5 * 10 ^ 2$ ，而 `2.5e2` 表示双精度的 $2.5 * 10 ^ 2$ 。Julia 也有 BigFloat 类型对任意精度的浮点数计算提供支持。

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
a, b = c, d
```

现在， a==3, b==4。特别是，交换两个数也特别简单：

```julia
a, b = b,a ＃现在a为4和b为3  
```

像在其他语言中一样，布尔运算`&&` `||` 和`!` 来进行与、或、非操作。Julia 也采用短路优化，意即：

- `a && b` 中，a 若为false 则b 不被计算
- `a || b` 中，a 若为true 则b 不被计算

而操作符号`&` `|` ，也可用于逻辑判断，但不作短路优化。

Julia 还支持整数的位运算。其中 ，整数n 在Julia 不存在如后的操作：`n++` 或 `n--`；虽然在C++ 或Java 可如此使用，但Julia 使用 `n += 1` 或 `n -= 1` 来代替。

有关操作的更详细的信息，如位运算，特殊优先级等等，参见[Julia 数学运算](http://docs.julialang.org/en/latest/manual/mathematical-operations/)。

## 有理数和复数

