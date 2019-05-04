package team.abc.ssm.modules.sys.dao;

import team.abc.ssm.modules.sys.entity.User;

import java.util.List;

public interface UserDao {

    // 通过用户名获取用户信息
    User selectByUsername(User user);

    // 模糊搜索结果总数
    int selectSearchCount(User user);

    // 获取所有用户列表
    List<User> selectAll();

    // 获取用户类型为老师和学生和博士后的用户列表
    List<User> selectTeacherStudentList();

    // 分页 + 搜索(模糊匹配用户名)获取用户列表（无角色信息）
    List<User> selectByPage(User user);

    // 复杂分页搜索
    List<User> selectListByPage(User user);

    // 上面出去分页的筛选总数
    int getCount(User user);

    // 根据ids获取用户列表（有角色信息）
    List<User> selectByIds(List<User> userList);

    // 添加一名新用户
    int insert(User user);

    // 更新用户信息
    int update(User user);

    int updateList(List<User> userList);

    // 删除指定id的用户
    int deleteByIds(List<User> userList);
}
