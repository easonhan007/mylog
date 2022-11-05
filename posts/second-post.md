{"title": "算法题", "created": "2022-10-27", "tags": ["alg", "python", "string"]}

最近寒风凛冽，估计不少同学都在刷算法题了，这里给大家介绍一个python实现的算法仓库，里面有很多常见算法的实现，有兴趣的同学可以先通过既有算法学习，掌握一些套路之后再由易到难把题刷起来。仓库地址：[https://github.com/keon/algorithms](https://github.com/keon/algorithms)

先给大家分享一个二进制加法的算法吧。

### 题目

输入：2个二进制的字符串

输出：也以二进制的方式返回相加后的结果

比如

```python
a = "11"
b = "1"
Return "100"
```

### 分析

这道题看完之后我基本上没有任何思路，丝毫没有一点点挣扎，直接看答案了。

### 实现

```python
def add_binary(a, b):
    s = ""
    c, i, j = 0, len(a)-1, len(b)-1
    zero = ord('0')
    while (i >= 0 or j >= 0 or c == 1):
        if (i >= 0):
            c += ord(a[i]) - zero
            i -= 1
        if (j >= 0):
            c += ord(b[j]) - zero
            j -= 1
        s = chr(c % 2 + zero) + s
        c //= 2 
        
    return s
```

看完以后发现实现思路非常的精妙。

首先确定’0’这个字符的ascii码，zero的值就是整形的48。

下面遍历两个字符串的每一位，从低位到高位，如果当前位存在的话，则取这一位的ascii码减去zero，因为是二进制，所以当前位的值要么是0要么是1，所以每次遍历相减后得到的结果要么是0要么是1，这就等于是把当前位从字符转成了二进制。所以后面如果有类似的字符或字符串转成二进制的题，可以参考每一位减去ascii 0的实现方式。

取一个数c，保存两个字符串当前位的和，所以c的取值一定是固定的

- 无进位的情况
    - c = 1 + 1 = 2
    - c = 1 + 0 = 1
    - c = 0 + 1 = 1
    - c = 0 + 0 = 0
- 有进位，c就等于1
    - c = 1 + 1 + 1 = 3
    - c = 1 + 0 + 1 = 2
    - c = 0 + 1 + 1 = 2
    - c = 1 + 0 + 0 = 1

好了，下面再用c去模2，在c = 2或者是0的时候，就可以得到当前位的值是0，c是1或3的时候当前位就是1，这里用取模的方式实现了二进制的加法，简单却深刻和优雅。

最后一步改变c的值，如果c=2的话，证明是有进位的，其他情况下没有进位，所以把c的值变成c除以2的商，当且仅当c为2的时候，c会变成1，其他情况下由于不能整除，c又恢复成0，优雅的用整除实现了进位。

### 分解

以a = 11, b = 1为例子，每次从ab里取1位，分别记作x，y，输出的字符串为s，因此我们有4个变量，x，y，c，s

1. x = 1, y = 1, c = x + y = 2, s = “” + c % 2 = “” + “0” = “0”, c = c / 2 = 1，第一步之后s是”0”, c = 1
2. x = 1, y = 0, c = x + y = 2, s = “0” + c % 2 = “0” + “0”, c = c / 2 = 1，这一步之后s是”00”, c = 1
3. c = 1, s = “0” + c % 2 = “00” + “1”, s = “100”, c = c / 2 = 1 / 2 = 0, 不满足循环条件，退出，最终结果100

### 总结

其实没啥好总结的，这道题看起来简单，但是不看答案真不知道该怎么下手。