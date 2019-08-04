# Document-Management-System
文献管理系统

## 目录
* [1. 登陆](#1登陆)
* [2. 系统功能](#2系统功能)
    * [2.1 用户管理](#21-用户管理)
    * [2.2 角色管理](#22-角色管理)
    * [2.3 功能管理](#23-功能管理)
    * [2.4 字典管理](#24-字典管理)
* [3.工具箱](#3工具箱)
    [* 3.1 Excel导入](#31-Excel导入)
* [4.文献管理](#4文献管理)
    * [4.1 论文用户匹配](#41-论文用户匹配)
    * [4.2 专利用户匹配](#42-专利用户匹配)
    * [4.3 文献统计](#43-文献统计)
    * [4.4 作者查询](#44-作者查询)
    * [4.5 期刊管理](#45-期刊管理)
    * [4.6 基金管理](#46-基金管理)

## 1.登陆
管理员（拥有系统所有权限）\
用户名：admin \
密码：admin

## 2.系统功能
包含了维持系统运作的基础功能

### 2.1 用户管理
可进行的操作有：\
添加用户，删除用户，编辑用户的信息，编辑用户的角色 \
初始化按钮用于初始化从Excel导入的用户的nicknames和tutor_nicknames字段

对应的实体表为sys_user \
相关的表有sys_map_user_role等 \
（当前用户表存在信息冗余等问题，建议后续将学生、教师、博士后独立出来，分成三张表，用户表只用作登陆）

### 2.2 角色管理
可对角色进行基本的增删改查操作，以及编辑角色拥有的功能 \
其中管理员角色自动拥有全部权限

对应的实体表为sys_role \
相关的表有sys_map_user_role、sys_map_role_function等

### 2.3 功能管理
所有功能以树的方式组织，总共二个层级，各层级中都按次序排列 \
第一层级为分类层，第二层级为具体页面 \
其中的权限码字段在后端的@RequirePermission等注解中使用，从而实现权限控制\
（shiro权限标识符的用法：https://minjiechenjava.iteye.com/blog/2252020 ） \
地址字段为具体页面的访问地址，在ViewController中注册

对应的实体表为sys_function \
相关的表有sys_map_role_function等 

### 2.4 字典管理
可对字典、字典类型进行基本的增删改查操作 \
当手动添加某一类型的字典项时，建议先选择字典类型（筛选）

对应的实体表为sys_dict、sys_dict_type

## 3.工具箱
用于存放一些工具性质的功能

### 3.1 Excel导入
分为模板管理和数据导入两个部分 \
模板管理可对导入模板进行增删改查 \
导入模板将数据库中的一张表和一个Excel模板关联在了一起，并存储了Excel中的列到表的字段的映射关系 \
要求Excel模板的第一行必须为列名，之后的行为数据行 \
编辑操作可对映射关系和模板名进行修改


对应的实体表为excel_template、excel_column_map_field

## 4. 文献管理
包含了本系统的主要业务功能

### 4.1 论文用户匹配
根据论文的作者列表（拼音），与用户表中的学生（nicknames,tutor_nicknames）、教师（nicknames）进行匹配，从而确认第一作者、第二作者的学号/工号（也有可能不存在） \
流程操作：\
1、在Excel导入功能中导入学生、教师的信息到用户表 \
2、在用户管理中点击初始化按钮 \
3、在Excel导入功能中导入论文 \
4、回到论文用户匹配功能 \
5、选择“1.未初始化”选项，此时可查看刚刚导入的论文 \
6、点击初始化对导入论文的部分字段进行一些处理 \
7、成功后自动选择“2.2初始化完成”，可在此查看初始化改变的一些字段信息 \
8、在“2.1被过滤”选项中可查看被过滤的论文（非本校、重复导入的论文（入藏号相同）） \
9、点击自动匹配 \
10、成功后自动选择“3.1匹配出错”，可在此查看并手动匹配匹配出错的项，对于修改好的论文可点击转入成功，使其进入匹配成功的状态 \
11、在“3.2匹配成功”选项中可查看本次匹配中所有匹配成功的论文 \
12、点击全部完成，即可将匹配成功状态的所有论文归入完成状态，完成本次匹配的所有流程


相关的表有doc_paper、sys_user、doc_danwei_nicknames（存储了单位的别名，用于将论文中的署名单位（别名）替换为唯一的中文名）等

### 4.2 专利用户匹配

### 4.3 文献统计

### 4.4 作者查询

### 4.5 期刊管理
可查看数据库中存储的所有期刊信息


对应的实体表为doc_journal

### 4.6 基金管理
可查看数据库中存储的所有基金信息


对应的实体表为doc_fund
