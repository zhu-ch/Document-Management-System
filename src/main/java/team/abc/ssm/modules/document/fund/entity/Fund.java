package team.abc.ssm.modules.document.fund.entity;

import lombok.Data;
import team.abc.ssm.common.persistence.DataEntity;

@Data
public class Fund extends DataEntity<Fund> {

    /**
     * 指标名称
     */
    private String metricName;

    /**
     * 姓名
     */
    private String personName;

    /**
     * 工号
     */
    private String personWorkId;

    /**
     * 年份
     */
    private Integer projectYear;

    /**
     * 项目名称
     */
    private String projectName;

    /**
     * 金额（万元）
     */
    private Integer projectMoney;

    /**
     * 备注
     */
    private String remarks;

    /**
     * 指标名称数据字典
     */
    private String metricMatch;

    /**
     * 匹配id
     */
    private String personId;

    /**
     * 学院
     */
    private String school;

    /**
     * -1未初始化 0未匹配 1匹配失败 2匹配成功
     */
    private String status;
}
