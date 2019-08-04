app = new Vue({
    el: '#app',
    data: {
        fullScreenLoading: false,
        urls: {
            getJournalList: '/api/doc/journal/list',
            deleteListByIds: '/api/doc/journal/deleteByIds'
        },
        table: {
            loading: false,
            selectionList: [],
            data: [],
            params: {
                searchKey: '',
                pageIndex: 1,
                pageSize: 10,
                pageSizes: [5, 10, 20, 40],
                total: 0
            }
        },
        dialog: {},
        options: {}
    },
    methods: {
        refreshTable: function () {
            let app = this;
            app.table.loading = true;
            let data = {
                page: app.table.params
            };
            ajaxPostJSON(this.urls.getJournalList, data, function (d) {
                app.table.loading = false;
                app.table.data = d.data.resultList;
                app.table.params.total = d.data.total;
            })
        },
        deleteByIds: function(journalList){
            if (journalList.length === 0) {
                window.parent.app.showMessage('提示：未选中任何项', 'warning');
                return;
            }
            window.parent.app.$confirm('确认删除选中的项', '警告', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                let data = journalList;
                let app = this;
                app.table.loading = true;
                ajaxPostJSON(this.urls.deleteListByIds, data, function (d) {
                    window.parent.app.showMessage('删除成功！', 'success');
                    app.refreshTable();
                })
            }).catch(() => {
                window.parent.app.showMessage('已取消删除', 'warning');
            });
        },
        // 打开编辑entity窗口
        openDialog_updateEntity: function (row) {
            this.dialog.updateEntity.visible = true;
            this.dialog.updateEntity.formData = copy(row);
        },
        // 处理选中的行变化
        onSelectionChange: function (val) {
            this.table.selectionList = val;
        },
        // 处理pageSize变化
        onPageSizeChange: function (newSize) {
            this.table.params.pageSize = newSize;
            this.refreshTable();
        },
        // 处理pageIndex变化
        onPageIndexChange: function (newIndex) {
            this.table.params.pageIndex = newIndex;
            this.refreshTable();
        },
        // 重置表单
        resetForm: function (ref) {
            this.$refs[ref].resetFields();
        },
        // 格式化时间为年份
        formatYear: function(timestamp){
            let date = new Date(timestamp);
            return date.Format("yyyy");
        }
    },
    mounted: function(){
        this.refreshTable();
    }
});