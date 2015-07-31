### 基于 Inferno 的集群与并行计算框架
---
这是我大二下操作系统的课程大作业，我们的组员有阮震元，解宇飞，杨智，刘旭彤<liuxt@mail.ustc.edu.cn>。指导老师为邢凯<kxing@ustc.edu.cn>.

#### 实现的功能
我们要做的是一个方便于用户的解释器。用户只要使用我们所规定的语言规范即可十分方便地将代码翻译成并行化代码。目前我们做了map,reduce,merge三个函数的并行化。并对其进行了容错处理。

#### 使用的平台：
* Linux as native system
* Inferno OS as host system

#### 使用方法
1. 安装：

示例：
	
	```
	127.0.0.1 192.168.0.1 192.168.0.2
	```

3. user.sh 的编写:用户首先需编写 user.sh, 然后经解释器翻译成并行化代码再执行. 所以 user.sh 的编写非常重要.

	@parallel_end
	```
4. 执行一个并行化程序:只需进入 Inferno 终端, 并进入工作目录/usr/inferno/parallel. 在此目录下编写 user.sh. 之后执行 sh finish.sh 即可完成对 user.sh 的翻译生成 device 和 host 代码.	

#### Contents
* Code
	* host_device_template
	* interpreter
	* map
	* merge
	* reduce
* Materials
	* inferno references
	* opencl
* Report
	* report paper
	* presentation slides
* Resources

#### 特性
* 日志功能方便调试
* 故障修复
* 跨平台
* 高度可扩展性与可配置性
* benchmark加速比高
* 支持异构
* 部署及编程简单


#### Bugs &amp; Patchs Reported
* arm架构下的编译bug
* arm架构下的网络接口bug
* 有关x86编译问题的patch

#### 不足
* 无法加速时间复杂度小于 O(n2) 的算法(或者函数),例如对 n 个数据 求和。具体的原因是 host 节点将数据分发出去,由于各个节点计算速 度不同,收回结果的函数必定是乱序的。我们小组对于乱序的结果必 须要进行排序,也就是说要根据 pid 为关键字进行排序。由于 Inferno 系统的自身因素,排序算法只能达到 O(n2)。所以本身时间复杂度小 于 O(n2) 的无法进行加速.

#### 完成过程中遇到的困难



我们进行了众多有益的探讨。最后感谢队友之间的集思广益、通力合作,以最高效的方式解决了各种棘手的问题。












