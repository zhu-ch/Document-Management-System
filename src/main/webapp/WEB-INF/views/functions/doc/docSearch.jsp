<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/4/2
  Time: 14:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>docSearch</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/doc/docSearch.css"/>
    <style>
        html {
            height: 100%;
            overflow: auto;
        }

        body {
            height: 100%;
            overflow: auto;
            color: #000;
        }

        .tmp {
            margin-top: 15px;
            background-color: rgb(237, 237, 238);
            border-radius: 4px;
            padding: 7px 0;
            box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1)
        }

        .commonInput {
            float: right;
            margin-left: 10px;
        }

        .commonInputSection {
            width: 300px;
            float: left;
            margin-left: 15px;
        }

        .selectText {
            float: left;
            width: 120px;
            padding-top: 6px;
            margin-left: 10px;
            /*margin-left: 15px;*/
            /*font-size: 15px;*/
        }

        .inputSpanText {
            float: left;
            padding-top: 12px;
        }

        .operateRow {
            padding: 7px 0;
        }

        /*日期选择框样式*/
        .el-date-editor .el-range-separator {
            padding: 0 0;
        }

        .has-gutter .cell{
            height: 45px;
            line-height: 45px;
        }
    </style>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;" v-loading="fullScreenLoading">
    <el-container style="height: 100%">
        <el-header height="auto">
            <div style="margin-top: 10px;">
                <template>
                    <el-radio v-model="radio" border label="1">作者查询</el-radio>
                    <el-radio v-model="radio" border label="2">文献统计</el-radio>
                </template>
            </div>
            <div style="margin-top: 10px" class="tmp" v-show="radio == 2">
                <template>
                    <el-checkbox :indeterminate="doc.isIndeterminate" v-model="doc.checkAll"
                                 style="float: left;margin-left:10px;margin-right: 10px"
                                 @change="handleCheckAllChange">全选
                    </el-checkbox>
                    <el-checkbox-group v-model="doc.checkedDoc" @change="handleCheckedDocsChange">
                        <el-checkbox :label="doc.docType.paper" :key="doc.docType.paper"></el-checkbox>
                        <el-checkbox :label="doc.docType.patent" :key="doc.docType.patent"></el-checkbox>
                        <el-checkbox :label="doc.docType.copyright" :key="doc.docType.copyright"></el-checkbox>
                    </el-checkbox-group>
                </template>
            </div>
            <%--搜索选项部分--%>
            <div id="commonBox" class="tmp" v-show="optionView.commonSelect.show">
                <row>
                    <span class="selectText" v-show="radio ==2">
                        <el-tag>公共筛选项</el-tag>
                    </span>
                    <div class="commonInputSection" v-show="radio ==1">
                        <span class="inputSpanText">作者身份: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.commonSelect.authorIdentity"
                                       filterable
                                       clearable
                                       placeholder="选择作者身份">
                                <el-option
                                        v-for="item in optionValue.authorIdentityOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                    <div class="commonInputSection" v-show="radio ==1">
                        <span class="inputSpanText">作者工号: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入作者工号"
                                    v-model="optionView.commonSelect.authorWorkNum"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">所属学科: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.commonSelect.subject"
                                       filterable
                                       clearable
                                       placeholder="选择所属学科">
                                <el-option
                                        v-for="item in optionValue.subjectOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">学校机构: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.commonSelect.organization"
                                       filterable
                                       clearable
                                       placeholder="选择学校机构">
                                <el-option
                                        v-for="item in optionValue.orgOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                </row>
                <row style="margin-top: 10px" v-show="radio ==2">
                    <div class="commonInputSection" style="width: 438px;margin-left: 145px">
                        <span class="inputSpanText">出版时间: </span>
                        <div class="commonInput">
                            <el-date-picker
                                    v-model="optionView.commonSelect.publishDate"
                                    type="daterange"
                                    align="right"
                                    unlink-panels
                                    range-separator="至"
                                    start-placeholder="开始日期"
                                    end-placeholder="结束日期"
                                    :picker-options="optionValue.pickerOptions">
                            </el-date-picker>
                        </div>
                    </div>
                </row>
            </div>

            <div id="paperBox" class="tmp" v-show="radio == 2 && optionView.paper.show">
                <row>
                    <span class="selectText">
                        <el-tag type="danger">论文筛选项</el-tag>
                    </span>
                    <div class="commonInputSection" v-show="radio ==1">
                        <span class="inputSpanText">论文名称:</span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="请输入内容"
                                    v-model="optionView.paper.paperName"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <%--&lt;%&ndash;paper-第一作者&ndash;%&gt;
                    <div class="commonInputSection">
                        <span class="inputSpanText">第一作者: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入第一作者工号/学号"
                                    v-model="optionView.paper.firstAuthorWorkNum"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    &lt;%&ndash;paper-第二作者&ndash;%&gt;
                    <div class="commonInputSection">
                        <span class="inputSpanText">第二作者: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入第二作者工号/学号"
                                    v-model="optionView.paper.secondAuthorWorkNum"
                                    clearable>
                            </el-input>
                        </div>

                    </div>
                    &lt;%&ndash;paper-其他作者&ndash;%&gt;
                    <div class="commonInputSection">
                        <span class="inputSpanText">其他作者: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入其他作者工号/学号"
                                    v-model="optionView.paper.otherAuthorWorkNum"
                                    clearable>
                            </el-input>
                        </div>
                    </div>--%>
                    <div class="commonInputSection">
                        <span class="inputSpanText">论文级别: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.paper.paperLevel" clearable placeholder="选择论文级别">
                                <el-option
                                        v-for="item in optionValue.paperLevelOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                    <%--  &lt;%&ndash;paper-期刊号&ndash;%&gt;
                      <div class="commonInputSection" style="margin-left: 145px">
                          <span class="inputSpanText">期刊号: </span>
                          <div class="commonInput">
                              <el-input
                                      placeholder="输入论文期刊号"
                                      v-model="optionView.paper.ISSN"
                                      clearable>
                              </el-input>
                          </div>
                      </div>
                      &lt;%&ndash;paper-入藏号&ndash;%&gt;
                      <div class="commonInputSection">
                          <span class="inputSpanText">入藏号: </span>
                          <div class="commonInput">
                              <el-input
                                      placeholder="输入论文入藏号"
                                      v-model="optionView.paper.storeNum"
                                      clearable>
                              </el-input>
                          </div>
                      </div>--%>

                    <div class="commonInputSection">
                        <span class="inputSpanText">影响因子: </span>
                        <div class="commonInput">
                            <el-input-number
                                    v-model="optionView.paper.impactFactor"
                                    @change=""
                                    :min="0"
                                    controls-position="right"
                                    size="medium"
                                    style="width: 211.42px"
                            <%--:max="10"--%>
                                    placeholder="输入论文影响因子">
                            </el-input-number>
                        </div>
                    </div>

                    <div class="commonInputSection">
                        <span class="inputSpanText">论文种类: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.paper.paperType" clearable placeholder="选择论文种类">
                                <el-option
                                        v-for="item in optionValue.paperTypeOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                </row>
            </div>

            <div id="patentBox" class="tmp" v-show="radio == 2 &&  optionView.patent.show">
                <row>
                    <span class="selectText">
                        <el-tag type="warning">专利筛选项</el-tag>
                    </span>
                    <div class="commonInputSection">
                        <span class="inputSpanText">专利申请号: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入专利申请号"
                                    v-model="optionView.commonSelect.applicationNum"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">专利公开号: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入专利公开号"
                                    v-model="optionView.commonSelect.publicNum"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                </row>
            </div>

            <div id="copyrightBox" class="tmp" v-show="radio == 2 &&  optionView.copyright.show">
                <row>
                    <span class="selectText">
                        <el-tag type="success">版权筛选项</el-tag>
                    </span>
                    <div class="commonInputSection">
                        <span class="inputSpanText">版权主体: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入版权主体"
                                    v-model="optionView.copyright.copySubject"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">版权类型: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入版权类型"
                                    v-model="optionView.copyright.copyType"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                </row>
            </div>

            <div style="height: 10px"></div>

            <row>
                <el-button
                        v-show="radio == 1"
                        type="primary" size="medium" @click="">查询作者</el-button>
                <div v-show="radio ==2">
                    <el-button type="primary" size="medium" @click="statisticalSearch()">统计结果</el-button>
                    <el-button type="danger" size="medium" @click="">结果导出</el-button>
                    <el-button type="success" size="medium" @click="test4">Test</el-button>
                </div>
            </row>

            <hr style="width: 100%;margin: 10px auto;"/>
        </el-header>

        <el-main style="margin-top: -35px;height: 100%">
            <%--作者查询列表--%>
            <div v-show="radio == 1" style="height: 100%;overflow: hidden">
                <el-table :data="table.authorTable.data"
                          :header-cell-style="{background:'rgb(0, 124, 196)',color:'#fff'}"
                          height="calc(100% - 50px)"
                          v-loading="table.commonTable.loading"
                          style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                          class="scroll-bar"
                <%--@selection-change="onSelectionChange_entity"--%>
                          stripe>
                    <el-table-column type="selection" width="60px">
                    </el-table-column>
                    <el-table-column
                            type="index"
                            label="序号"
                            header-align="center"
                            align="center"
                            width="80px">
                    </el-table-column>
                    <el-table-column
                            prop="authorName"
                            header-align="center"
                            align="center"
                            label="作者姓名">
                    </el-table-column>
                    <el-table-column
                            prop="authorWorkNum"
                            header-align="center"
                            align="center"
                            label="作者工号">
                    </el-table-column>
                    <el-table-column
                            prop="subject"
                            header-align="center"
                            align="center"
                            label="所属学科">
                    </el-table-column>
                    <el-table-column
                            prop="organization"
                            header-align="center"
                            align="center"
                            label="所属机构">
                    </el-table-column>
                    <el-table-column
                            prop="paperAmount"
                            header-align="center"
                            align="center"
                            label="论文数量">
                    </el-table-column>
                    <el-table-column
                            prop="patentAmount"
                            header-align="center"
                            align="center"
                            label="专利数量">
                    </el-table-column>
                    <el-table-column
                            prop="copyrightAmount"
                            header-align="center"
                            align="center"
                            label="著作权数量">
                    </el-table-column>
                    <el-table-column label="操作" width="190px" header-align="center" align="center">
                        <template slot-scope="scope">
                            <el-button type="primary" plain
                                       size="mini"
                                       style="position:relative;bottom: 1px;"
                                       @click="">
                                <span>查看作者详情</span>
                            </el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <%-- entity分页 --%>
                <el-pagination style="text-align: center;margin: 8px auto;"
                              <%-- @size-change="onPageSizeChange_entity"
                               @current-change="onPageIndexChange_entity"--%>
                               :current-page="table.authorTable.params.pageIndex"
                               :page-sizes="table.authorTable.params.pageSizes"
                               :page-size="table.authorTable.params.pageSize"
                               :total="table.authorTable.params.total"
                               layout="total, sizes, prev, pager, next, jumper">
                </el-pagination>
            </div>

            <%--文献统计列表--%>
            <div v-show="radio == 2">
                <el-table :data="table.commonTable.data"
                          :header-cell-style="{background:'rgb(79, 165, 254)',color:'#fff'}"
                          v-loading="table.commonTable.loading"
                          style="width: 100%;overflow-y: hidden;
                          margin-top: 20px;"
                          class="scroll-bar"
                          show-summary
                <%--:summary-method="getSummaries"
                @selection-change="onSelectionChange_entity"--%>
                          stripe>
                    <el-table-column
                            type="index"
                            label="序号"
                            header-align="center"
                            align="center"
                            width="80px">
                    </el-table-column>
                    <el-table-column
                            prop="docType"
                            header-align="center"
                            align="center"
                            label="文献类型">
                    </el-table-column>
                    <el-table-column
                            prop="totalDocAmount"
                            header-align="center"
                            align="center"
                            label="文献总数目">
                    </el-table-column>

                    <el-table-column label="文献分类"
                                     align="center"
                                     header-align="center">
                        <el-table-column
                                prop="teacherDocAmount"
                                header-align="center"
                                align="center"
                                label="教师文献数目">
                        </el-table-column>
                        <el-table-column
                                prop="studentDocAmount"
                                header-align="center"
                                align="center"
                                label="学生文献数目">
                        </el-table-column>
                        <el-table-column
                                prop="postdoctoralDocAmount"
                                header-align="center"
                                align="center"
                                label="博士后文献数目">
                        </el-table-column>
                    </el-table-column>

                    <el-table-column label="操作" width="190px" header-align="center" align="center">
                        <template slot-scope="scope">
                            <el-button type="primary" plain
                                       size="mini"
                                       style="position:relative;bottom: 1px;"
                                       @click="viewStatistics(scope.row)">
                                <span>查看统计详情</span>
                            </el-button>
                        </template>
                    </el-table-column>
                </el-table>
            </div>
        </el-main>
    </el-container>
</div>


<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script>
    const docOptions = ["论文", "专利", "著作权"];
    var app = new Vue({
        el: '#app',
        data: {
            radio: "1",
            doc: {
                checkAll: false,
                docType: {
                    /*应该从字典项中查询：*/
                    paper: "论文",
                    patent: "专利",
                    copyright: "著作权"
                },
                checkedDoc: [],
                isIndeterminate: true
            },
            //条件输入(选择)框的候选项：
            optionValue: {
                paperTypeOption: [],
                orgOption:[],
                authorIdentityOption: [
                    {
                        label: "教师",
                        value: "teacher"
                    },
                    {
                        label: "学生",
                        value: "student"
                    },
                    {
                        label: "博士后",
                        value: "postdoctoral"
                    }
                ],
                subjectOption: [
                    {
                        label: "哲学",
                        value: "philosophy"
                    },
                    {
                        label: "经济学",
                        value: "economics"
                    },
                    {
                        label: "法学",
                        value: "law"
                    },
                    {
                        label: "教育学",
                        value: "education"
                    },
                    {
                        label: "文学",
                        value: "literature"
                    },
                    {
                        label: "历史学",
                        value: "history"
                    },
                    {
                        label: "理学",
                        value: "science"
                    },
                    {
                        label: "工学",
                        value: "engineering"
                    },
                    {
                        label: "农学",
                        value: "agronomy"
                    },
                    {
                        label: "医学",
                        value: "medicine"
                    },
                    {
                        label: "军事学",
                        value: "military"
                    },
                    {
                        label: "管理学",
                        value: "management"
                    },
                ],
                paperLevelOption: [
                    {
                        label: "第一级",
                        value: 1
                    },
                    {
                        label: "第二级",
                        value: 2
                    },
                    {
                        label: "第三级",
                        value: 3
                    },
                    {
                        label: "第四级",
                        value: 4
                    },
                    {
                        label: "第五级",
                        value: 5
                    },
                    {
                        label: "第六级",
                        value: 6
                    },
                ],
                pickerOptions: {
                    shortcuts: [{
                        text: '最近一周',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
                            picker.$emit('pick', [start, end]);
                        }
                    }, {
                        text: '最近一个月',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
                            picker.$emit('pick', [start, end]);
                        }
                    }, {
                        text: '最近三个月',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
                            picker.$emit('pick', [start, end]);
                        }
                    }]
                }
            },

            //条件输入(选择)框(V-model绑定的值)：
            optionView: {
                commonSelect: {
                    show: true,
                    authorIdentity: "",                             //作者工号
                    authorWorkNum: "",
                    publishDate: "",
                    subject: "",
                    organization:""
                },
                paper: {
                    show: false,
                    paperName: "",
                    firstAuthorWorkNum: "",
                    secondAuthorWorkNum: "",
                    otherAuthorWorkNum: "",
                    ISSN: "",
                    storeNum: "",
                    paperType: "",
                    /*new add*/
                    impactFactor: "",                                //影响因子
                    paperLevel: ""                                   //论文级别
                },
                patent: {
                    show: false,
                    applicationNum: "",
                    publicNum: "",
                    countryCode: ""
                },
                copyright: {
                    show: false,
                    copySubject: "",
                    copyType: ""
                }
            },
            fullScreenLoading: false,
            //表格
            table: {
                paperTable: {
                    urls: {
                        // insertEntity: '/api/doc/search/insert',
                        // deleteEntityListByIds: '/api/doc/search/deleteListByIds',
                        // updateEntity: '/api/doc/search/update',
                        // selectPaperListByPage: '/api/doc/search/selectListByPage',
                    },
                    data: [],
                    loading: false,
                    selectionList: [],
                    params: {
                        pageIndex: 1,
                        pageSize: 10,
                        pageSizes: [5, 10, 20, 40],
                        searchKey: '',  // 搜索词
                        total: 0,       // 总数
                    }
                },
                authorTable: {
                    loading: false,
                    data: [
                        {
                            authorName:"zm",
                            authorIdentity:"学生",
                            authorWorkNum:"112016xxxx",
                            subject:"哲学",
                            organization:"软件学院",
                            paperAmount :100,
                            patentAmount:10,
                            copyrightAmount:30
                        }
                    ],
                    selectionList: [],
                    params: {
                        pageIndex: 1,
                        pageSize: 10,
                        pageSizes: [5, 10, 20, 40],
                        searchKey: '',  // 搜索词
                        total: 0,       // 总数
                    }
                },
                commonTable: {
                    data: [
                        {
                            docType: "论文",
                            totalDocAmount: 300,
                            teacherDocAmount: 100,
                            studentDocAmount: 100,
                            postdoctoralDocAmount: 100
                        },
                        {
                            docType: "专利",
                            totalDocAmount: 300,
                            teacherDocAmount: 100,
                            studentDocAmount: 100,
                            postdoctoralDocAmount: 100
                        },
                        {
                            docType: "著作权",
                            totalDocAmount: 300,
                            teacherDocAmount: 100,
                            studentDocAmount: 100,
                            postdoctoralDocAmount: 100
                        }
                    ],
                    loading: false,
                    selectionList: [],
                    params: {
                        pageIndex: 1,
                        pageSize: 10,
                        pageSizes: [5, 10, 20, 40],
                        searchKey: '',  // 搜索词
                        total: 0,       // 总数
                    }
                }
            },
            dialog: {},
            options: {},
        },
        methods: {
            handleCheckAllChange(val) {
                this.doc.checkedDoc = val ? docOptions : [];
                this.doc.isIndeterminate = false;
                optionViewSelect();
            },
            handleCheckedDocsChange(value) {
                let checkedCount = value.length;
                console.log("checkedDoc：" + app.doc.checkedDoc);
                this.doc.checkAll = checkedCount === 3;
                this.doc.isIndeterminate = checkedCount > 0 && checkedCount < 3;
                optionViewSelect();
            },

            /*查看文献统计详情*/
            viewStatistics: function (row) {
                if (row.docType === "论文") {
                    let data = {
                        paperName: app.optionView.paper.paperName,
                        firstAuthorName: app.optionView.paper.firstAuthorWorkNum,            //其实是FA工号
                        secondAuthorName: app.optionView.paper.secondAuthorWorkNum,          //其实是SA工号
                        authorList: app.optionView.paper.otherAuthorWorkNum,                 //其实是OA工号
                        storeNum: app.optionView.paper.storeNum,
                        paperType: app.optionView.paper.paperType,
                        ISSN: app.optionView.paper.ISSN,
                        pageIndex: app.table.paperTable.params.pageIndex,
                        pageSize: app.table.paperTable.params.pageSize
                    };
                    let getParam = formatParams(data);
                    let getLink = "/api/doc/search/selectPaperListByPageGet?" + getParam;
                    console.log(getLink);
                    window.parent.app.addTab("论文", getLink);
                } else if (row.docType === "专利") {
                    alert("专利统计详情页面");
                } else {
                    alert("著作权统计详情页面");
                }
            },

            /*paper_table函数*/
            insertPaper: function () {

            },
            deletePaperListByIds: function () {

            },
            updatePaper: function () {

            },
            selectPaperListByPage: function () {
                //formatParams
                let data = {
                    paperName: app.optionView.paper.paperName,
                    firstAuthorName: app.optionView.paper.firstAuthorWorkNum,            //其实是FA工号
                    secondAuthorName: app.optionView.paper.secondAuthorWorkNum,          //其实是SA工号
                    authorList: app.optionView.paper.otherAuthorWorkNum,                 //其实是OA工号
                    storeNum: app.optionView.paper.storeNum,
                    docType: app.optionView.paper.paperType,
                    ISSN: app.optionView.paper.ISSN,
                    page: app.table.paperTable.params
                };
                console.log("post: " + data);
                app.table.paperTable.loading = true;
                ajaxPostJSON("/api/doc/search/selectPaperListByPagePost", data,
                    function success(res) {
                        app.table.paperTable.loading = false;
                        console.log("post请求成功" + res);
                        app.table.paperTable.data = res.data.paperList;
                        app.table.paperTable.params.total = res.data.paperAmount;
                    },
                    function error(res) {
                        console.log("post请求失败: " + res);
                    }
                );
            },
            // 刷新entity table数据
            refreshTable_paper: function () {
                console.log("刷新entity table数据");
                app.selectPaperListByPage();
            },
            // 处理选中的行变化
            onSelectionChange_paper: function (val) {
                this.table.paperTable.selectionList = val;
            },
            // 处理pageSize变化
            onPageSizeChange_paper: function (newSize) {
                console.log("处理pageSize变化");
                app.table.paperTable.params.pageSize = newSize;
                app.refreshTable_paper();
            },
            // 处理pageIndex变化
            onPageIndexChange_paper: function (newIndex) {
                console.log("处理pageIndex变化");
                app.table.paperTable.params.pageIndex = newIndex;
                app.refreshTable_paper();
            },

            // 重置表单
            // resetForm: function (ref) {
            //     this.$refs[ref].resetFields();
            // },

            /*统计搜索*/
            statisticalSearch: function () {
                /*let paperIndex = $.inArray('论文', app.doc.checkedDoc);
                let patentIndex = $.inArray('专利', app.doc.checkedDoc);
                let copyrightIndex = $.inArray('著作权', app.doc.checkedDoc);*/

                let paramsData = {
                    commonParams: {
                        authorIdentity: app.optionView.commonSelect.authorIdentity,
                        subject: app.optionView.commonSelect.subject,
                        authorWorkNum: app.optionView.commonSelect.authorWorkNum,
                        pubDate: app.optionView.commonSelect.publishDate
                    },
                    paperParams: {
                        paperName: app.optionView.paper.paperName,
                        paperLevel: app.optionView.paper.paperLevel,
                        IF: app.optionView.paper.impactFactor,
                        paperType: app.optionView.paper.paperType
                    },
                    patentParams: {
                        applicationNum: app.optionView.patent.applicationNum,
                        publicNum: app.optionView.patent.publicNum
                    },
                    copyrightParams: {
                        copySubject: app.optionView.copyright.copySubject,
                        copyType: app.optionView.copyright.copyType
                    }
                };
                app.table.commonTable.loading = true;

                let jsonParamsData = JSON.stringify(paramsData);

                $.ajax({
                    url: "/doc/statisticalSearch",
                    type: "post",
                    data: {jsonStr: jsonParamsData},
                    //contentType: 'application/json;charset=utf-8',
                    success: function (res) {
                        console.log(res)
                    },
                    error: function (res) {
                        console.log("post error:" + res)
                    }
                });

                // ajaxPostJSON("/doc/statisticalSearch",{jsonStr:paramsData},
                // function success(res) {
                //     if(res.code === 'success'){
                //         console.log("ok")
                //     }else{
                //         console.log("bu ok")
                //     }
                // },
                // function error(res) {
                //     console.log("post error"+ res)
                // });
                app.table.commonTable.loading = false;
            },

            /*查看文献详情：*/
            viewDocDetails(row) {
                parent.addTab1("文献详情test1", "api/doc/search/docDetails");
                // alert($('#default', window.parent.document).html());
                console.log(row);
                ajaxGet("api/doc/search/docDetails", null,
                    function success(res) {
                        console.log(res);
                    },
                    function error(res) {
                        console.log(res);
                    })
            },

            getSummaries(param) {
                const {columns, data} = param;
                const sums = [];
                columns.forEach((column, index) => {
                    if (index === 1) {
                        sums[index] = '总价';
                        return;
                    }
                    const values = data.map(item => Number(item[column.property]));
                    if (!values.every(value => isNaN(value))) {
                        sums[index] = values.reduce((prev, curr) => {
                            const value = Number(curr);
                            if (!isNaN(value)) {
                                return prev + curr;
                            } else {
                                return prev;
                            }
                        }, 0);
                        sums[index] += ' 元';
                    } else {
                        sums[index] = 'N/A';
                    }
                });
                return sums;
            }
        }
    });

    //选择对应筛选框视图:
    function optionViewSelect() {
        app.optionView.paper.show = false;
        app.optionView.patent.show = false;
        app.optionView.copyright.show = false;
        // app.optionView.commonSelect.show = app.doc.checkedDoc.length <= 0;

        for (let i = 0; i < app.doc.checkedDoc.length; i++) {
            let tmpType = app.doc.checkedDoc[i];
            switch (tmpType) {
                case "论文":
                    app.optionView.paper.show = true;
                    break;
                case "专利":
                    app.optionView.patent.show = true;
                    break;
                case "著作权":
                    app.optionView.copyright.show = true;
                    break;
                default:
                    break;
            }
        }
    }

    //1. 格式化URL参数(传入单个参数对象)
    function formatParams(data) {
        let arr = [];
        for (let name in data) {
            arr.push(encodeURIComponent(name) + '=' + encodeURIComponent(data[name]));
        }
        // 添加一个随机数参数，防止缓存
        arr.push('v' + Math.random() + '=' + Math.random());
        //console.log(arr.join('&'));
        return arr.join('&');
    }

    //2. 格式化REL参数(传入参数对象数组)
    function formatParamsArray(data) {
        let arr = [];
        for (let i = 0; i < data.length; i++) {
            let tmpData = data[i];
            for (let name in tmpData) {
                arr.push(encodeURIComponent(name) + '=' + encodeURIComponent(tmpData[name]));
            }
        }
        arr.push('v=' + Math.random());
        return arr.join('&');
    }

    //初始化界面时候加载默认参数：
    function initialize() {
        /*初始化paperType*/
        let tmp = ${paperType};
        for (let i = 0; i < tmp.length; i++) {
            let tmpItem = {
                value: tmp[i].id,
                label: tmp[i].name_en
            };
            app.optionValue.paperTypeOption.push(tmpItem);
        }
        /*初始化学校机构*/
        let org = ${orgList};
        for (let i = 0; i<org.length;i++){
            let tmpOrg = {
                value:org[i].id,
                label:org[i].org_name
            };
            app.optionValue.orgOption.push(tmpOrg);
        }
    }

    window.onload = function () {
        // app.selectPaperListByPage();
        initialize();
    };

    // 测试
    function test() {
        let tmpData = {
            id: "tmpId",
            name: "tmpName"
        };
        ajaxGet('/api/doc/search/test', tmpData, function success(res) {
                console.log("ok");
                console.log(res);
                console.log(res.data.paper)
            },
            function error(res) {
                console.log("请求失败"),
                    console.log(res);
            })
    }

    function test2() {

        let paperConditionParam = {
            paperName: app.optionView.paper.paperName,
            firstAuthorWorkNum: app.optionView.paper.firstAuthorWorkNum,
            secondAuthorWorkNum: app.optionView.paper.secondAuthorWorkNum,
            otherAuthorWorkNum: app.optionView.paper.otherAuthorWorkNum,
            ISSN: app.optionView.paper.ISSN,
            storeNum: app.optionView.paper.storeNum,
            docType: app.optionView.paper.paperType,                    //paperType 的id
            paperPageIndex: app.table.paperTable.params.pageIndex,
            paperPageSize: app.table.paperTable.params.pageSize
        };
        let patentConditionParam = {
            applicationNum: "专利申请号2",
            publicNum: "专利公开号2",
            countryCode: "专利国别码2",
            patentPageIndex: 1,
            patentPageSize: 10
        };
        let copyrightConditionParam = {
            copySubject: "版权主体2",
            copyType: "版权类型2",
            copyPageIndex: 1,
            copyPageSize: 10
        };
        //全部参数：
        let paramObjectArray = [paperConditionParam, patentConditionParam, copyrightConditionParam];
        let conditionParam = formatParamsArray(paramObjectArray);
        console.log(conditionParam);

        ajaxPost("/api/doc/search/getDocList", conditionParam,
            function success(res) {
                console.log("success " + res);
            },
            function error(res) {
                console.log("error " + res)
            }
        )

    }

    //模态框测试：
    function test3() {
        app.$prompt('Module Test', 'Notice', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
        }).then(({value}) => {
            app.$message({
                type: 'success',
                message: '输入信息是: ' + value
            });
        }).catch(() => {
            app.$message({
                type: 'info',
                message: '取消输入'
            });
        });
    }

    // function paperSearch() {
    //     let data = {
    //         paperName:app.optionView.paper.paperName,
    //         firstAuthorName:app.optionView.paper.firstAuthorWorkNum,            //其实是FA工号
    //         secondAuthorName:app.optionView.paper.secondAuthorWorkNum,          //其实是SA工号
    //         authorList:app.optionView.paper.otherAuthorWorkNum,                 //其实是OA工号
    //         ISSN:app.optionView.paper.ISSN,
    //         storeNum:app.optionView.paper.storeNum,
    //         docType:app.optionView.paper.paperType,
    //         page: app.table.paperTable.params
    //     };
    //
    //     console.log(data);
    //     app.table.paperTable.loading = true;
    //     ajaxPostJSON("/api/doc/search/selectListByPage", data,
    //         function success(res) {
    //             app.table.paperTable.loading = false;
    //             console.log(res);
    //             app.table.paperTable.data = res.data;
    //             //app.table.entity.params.total = d.data.total;
    //         },
    //         function error(res) {
    //             console.log("error: " + res);
    //         });
    // }

    function test4() {
        /*输出时间段*/
        console.log(app.optionView.commonSelect.publishDate);
    }
</script>

<%--<script src="/static/js/functions/doc/docSearch.js"></script>--%>
</body>
</html>