# npyread

#### 为什么有这个项目

由于MATLAB和Python在数值计算精度方面存在差异[存在差异](https://scicomp.stackexchange.com/questions/29595/matrix-multiplication-accuracy-matlab-vs-python)，为了调试方便，经常需要在MATLAB和Python之间传递数据。

Python中有[scipy.io.loadmat](https://docs.scipy.org/doc/scipy/reference/generated/scipy.io.loadmat.html)可以读取MATLAB导出的*.mat文件，但是MATLAB中并没有读取npy文件的函数。因而有了这个项目。

#### 如何使用

**1. 读取npy文件头**

`info = npyinfo('data.npy')` 

**2. 读取数据**

`data = npyread('data.npy')`

#### 参与贡献

1. Fork 本仓库
2. 新建 Feat_xxx 分支
3. 提交代码
4. 新建 Pull Request
