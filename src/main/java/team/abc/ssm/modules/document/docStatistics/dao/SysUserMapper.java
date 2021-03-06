package team.abc.ssm.modules.document.docStatistics.dao;
import org.apache.ibatis.annotations.Param;
import java.util.List;

import team.abc.ssm.modules.document.docStatistics.entity.SysUser;

public interface SysUserMapper {
    int deleteByPrimaryKey(String id);

    int insert(SysUser record);

    int insertSelective(SysUser record);

    SysUser selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(SysUser record);

    int updateByPrimaryKey(SysUser record);

    List<SysUser> selectAllByRealName(@Param("realName")String realName);

    List<SysUser> selectByRealName(@Param("realName")String realName);

    List<SysUser> selectByRealNameAndUserType(@Param("realName")String realName,@Param("userType")String userType);

    List<SysUser> selectByRealNameAndSchool(@Param("realName")String realName,@Param("school")String school);

    SysUser selectByWorkId(@Param("workId")String workId);

    List<SysUser> selectListByPage(SysUser sysUser);

    List<SysUser> selectTheWholeUser();

    List<SysUser> getAllUser();
}