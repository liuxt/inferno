### 基于 Inferno 的集群与并行计算框架
---
这是我大二下操作系统的课程大作业，我们的组员有阮震元，解宇飞，杨智，刘旭彤<liuxt@mail.ustc.edu.cn>。指导老师为邢凯<kxing@ustc.edu.cn>.

#### 实现的功能
我们要做的是一个方便于用户的解释器。用户只要使用我们所规定的语言规范即可十分方便地将代码翻译成并行化代码。目前我们做了map,reduce,merge三个函数的并行化。并对其进行了容错处理。

#### 使用的平台：
* Linux as native system
* Inferno OS as host system

#### 使用方法
1. 安装：由于需要较多的源文件混合编译, 我们采取使用 GNU automake 和 autoconf 套装进行自动化编译. 用户需先安装 >=1.11 的 automake 以及 >=2.13 的 autoconf. 然后进入源文件夹执行./configure 进行自动配置. 然后 再通过 make, 完成自动编译. 最终通过 make install 将程序安装在/usr/bin 中. 若想清理编译的中间文件可执行 make clean.
2. 配置 device_ip：在运行并行程序之前, 我们需要配置 device 的 IP 地址. 配置十分简 单, 只需在源文件夹里创建 device_ip 这一文件, 首先填 127.0.0.1 代表 localhost 地址即 host 地址. 接着再填入各个 device 的 IP 地址, 注意各个 地址之间需空一格.
示例：
	
	```
	127.0.0.1 192.168.0.1 192.168.0.2
	```

3. user.sh 的编写:用户首先需编写 user.sh, 然后经解释器翻译成并行化代码再执行. 所以 user.sh 的编写非常重要.user.sh 的语法格式和 Inferno Shell 及其相似. 其中串行部分格式和 Inferno Shell 完全相同. 并行部分格式如下:
	```	@parallel_begin  	parallel code blocks . . . . .  
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
* 无法加速时间复杂度小于 O(n2) 的算法(或者函数),例如对 n 个数据 求和。具体的原因是 host 节点将数据分发出去,由于各个节点计算速 度不同,收回结果的函数必定是乱序的。我们小组对于乱序的结果必 须要进行排序,也就是说要根据 pid 为关键字进行排序。由于 Inferno 系统的自身因素,排序算法只能达到 O(n2)。所以本身时间复杂度小 于 O(n2) 的无法进行加速.* 由于我们小组使用的是 Inferno 的内嵌语言,类似于 JVM,是对程序 是进行逐行解释运行的。这导致我们小组设计的框架速度受限。* 我们小组使用了 host-device 平台模型。这就说明 host 一旦宕机整个 系统就会崩溃,无法再进行故障修复。但是,经过我们查阅了大量的 资料发现:大量并行框架也是采用此模型,如 CUDA、OpenCL。可 以预见,这两种模型也会出现类似的问题。当然,对于 MPI,由于使 用了广播与点对点结合的通信方式,任务发起者一旦宕机,同样也无 法恢复。综上,这点不足也正是业界亟待解决的难题。

#### 完成过程中遇到的困难
* 起初在 64 位 Linux 上编译 inferno 源代码无法通过,还有在移植到 arm 平台上遇到 bug,通过查阅资料,并和 inferno 官方人员交流,最 终成功将其移植到 64 位的平台和 Raspberry Pi 上。* 由于 inferno 系统普及程度不高,导致可以参考的资料非常匮乏,几乎 只有官方网站上仅有的一点资料,给深入地学习带来困难,需要不断 自己摸索尝试。* inferno 系统提供的 shell 脚本语言功能有限,给代码编写造成困难, 比如 inferno 的 shell 语言没有数组,导致 map 和 merge 函数并行部 分结束之后必须进行表排序,降低了执行效率。* inferno系统偶尔出现命令执行结果不稳定的bug,导致3个并行函数 中作为计算完成标志的 finish 文件不能删除,然而不影响计算结果的 正确性,令人比较困惑。还会出现输入运行程序命令后,一段时间没 有反应,输入若干次回车之后才有反应的情况。* 起初在三台以上节点上运行时,file2chan 分发任务不正确,经过查阅 资料、阅读源代码,并做了大量实验之后,找到了解决方法,可以正 确运行在多台机器上。* 由于 inferno 系统不是很完善,代码执行出错后提供的错误信息很少, 并且调试工具不完善,导致程序调试困难,只能通过检查代码和输出 变量的方式,降低了开发的效率。
#### 致谢
* **本项目是在邢凯老师的悉心指导下完成的。**  * 首先十分感谢邢凯老师,给与我们极大的关心与帮助,为我们提供许多 问题解决的方案。其次十分感谢 Inferno 原作者 Charles Forsyth,感谢他与 我们进行了有益的探讨,一同解决了 Inferno 在 amd64 下编译的问题以及 在 arm 环境下 Inferno 编译和网络接口问题。感谢 Pete Elmore 的博文为 我们带来灵感。感谢安虹老师为我们提供研究场所,让我们专心研究课题。 感谢张智帅学长为我们提供树莓派以及嵌入式开发板。感谢余家辉学长与104
我们进行了众多有益的探讨。最后感谢队友之间的集思广益、通力合作,以最高效的方式解决了各种棘手的问题。













