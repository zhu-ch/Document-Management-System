package team.abc.ssm.modules.doc.entity;

import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;

import java.util.Date;

/**
 * @ClassName StatisticCondition
 * @Description 统计用筛选条件
 * @Author zm
 * @Date 2019/8/5 14:48
 * @Version 1.0
 **/
@Data
public class StatisticCondition extends DataEntity<StatisticCondition> {
    /**
    * 学科
    */
    private String subject;

    /**
     * 学院/单位
     */
    private String institute;

    /**
     * 统计开始日期
     */
    private Date startDate;

    /**
     * 统计结束日期
     */
    private Date endDate;

    /**
     * 论文种类
     */
    private String paperType;

    /**
     * 影响因子(下限)
     */
    private double impactFactorMin;

    /**
     * 影响因子(上限)
     */
    private double impactFactorMax;

    /**
     * 期刊种类
     */
    private String journalDivision;

    /**
     * 专利种类
     */
    private String patentType;

    /**
     * 作者身份：导师、学生、博士后
     */
    private String authorType;

    /**
     * 论文/专利的状态值
     * 专利为：'4'->代表已经完成匹配
     * 论文为：'3'->代表已经完成匹配
     */
     private String status;
}
