
## 定义函数

函数是的功能是传入一些参数（参数列表`arglist` ），然后在函数体中进行一些操作，接着返回零个，一个或多个值。多个参数之间用英文逗号分隔（事实上，他们形成了一个元组Tuple，跟返回值一样的结构。可以参考[第5章 集合类型](../ch5/) ）。这些参数也可是任选类型的，或者用户定义的类型。一般的语法如下：

```julia
function fname(arglist)
    # function body...
    return value(s)
end
```

一个函数的参数列表也可以为空，则写为`fname()`。

下面是一个简单的例子：

```julia
function mult(x, y)
       println("x is $x and y is $y")
       return x * y
end
```

如`mult` 的函数名按照惯例小写且不带下划线的。它们可以包含Unicode字符，这在数学符号中就颇有用。在最后一行`return` 关键字是可选的;上面例子我们也可以写成`x * y`。一般情况下，函数会返回最后一个表达式的值。但是写`return` 的好处主要在于多行代码的函数中，增加可读性。

该函数若被调用，其中`n = mult(3, 4)` 将返回12，并新的值赋给变量 n。你也可以通过调用`fname(arglist)` 来执行函数，从而只需要它的副作用（比如改变程序的部分状态;例如，改变全局变量）。`return` 关键字也可以在函数体某个部分（比如一个判断条件内）从而提前退出函数体，如在本实例：

```julia
function mult(x, y)
    println("x is $x and y is $y")
    if x == 1 
      return y 
    end
    x * y
end
``` 

在这种情况下，也可以使用不带值的`return`，使得该函数返回`nothing` 。


