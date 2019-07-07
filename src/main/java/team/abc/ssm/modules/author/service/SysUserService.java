package team.abc.ssm.modules.author.service;

import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import team.abc.ssm.modules.author.dao.SysUserMapper;
import team.abc.ssm.modules.author.entity.SysUser;
@Service
public class SysUserService{

    @Resource
    private SysUserMapper sysUserMapper;

    
    public int deleteByPrimaryKey(String id) {
        return sysUserMapper.deleteByPrimaryKey(id);
    }

    
    public int insert(SysUser record) {
        return sysUserMapper.insert(record);
    }

    
    public int insertSelective(SysUser record) {
        return sysUserMapper.insertSelective(record);
    }

    
    public SysUser selectByPrimaryKey(String id) {
        return sysUserMapper.selectByPrimaryKey(id);
    }

    
    public int updateByPrimaryKeySelective(SysUser record) {
        return sysUserMapper.updateByPrimaryKeySelective(record);
    }

    
    public int updateByPrimaryKey(SysUser record) {
        return sysUserMapper.updateByPrimaryKey(record);
    }

}
