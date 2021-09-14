<template>
  <v-data-table
    :headers="headers"
    :items="assessments"
    :options.sync="options"
    :server-items-length="all_data_count"
    :loading="loading"
    class="elevation-1 my-16"
  >
    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>評価結果一覧</v-toolbar-title>
        <v-col cols="9" sm="2" md="2">
          <v-select
            label="実験ID"
            :items="exp_ids"
            v-model="search_exp_id"
            class="mx-2 mt-4"
            @input="searchData()"
          ></v-select>
        </v-col>
        <v-col cols="9" sm="2" md="2">
          <v-select
            label="評価ID"
            :items="assess_ids"
            v-model="search_assess_id"
            class="mx-2 mt-4"
            @input="searchData()"
          ></v-select>
        </v-col>
        <v-col cols="9" sm="2" md="2">
          <v-select
            label="ユーザID"
            :items="user_ids"
            v-model="search_user_id"
            class="mx-2 mt-4"
            @input="searchData()"
          ></v-select>
        </v-col>
        <v-btn class="mb-2" @click="reset()" outlined> リセット </v-btn>
        <v-spacer></v-spacer>
        <v-btn color="primary" class="mb-2 mr-2" @click="downloadCSV()">
          CSVダウンロード
        </v-btn>
      </v-toolbar>
    </template>

    <template v-slot:[`item.updated_at`]="{ item }">
      <span>{{ new Date(item.updated_at).toLocaleString() }}</span>
    </template>

    <template v-slot:[`item.actions`]="{ item }">
      <v-icon small class="mr-2" @click="toEdit(item)">mdi-pencil</v-icon>
    </template>

    <template v-slot:no-data> データがありません </template>
  </v-data-table>
</template>

<script>
import AssessmentApi from '@/plugins/axios/modules/assessment'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',

  data: () => ({
    headers: [
      { text: '実験ID', value: 't_experiment_id' },
      { text: '実験名', value: 'name' },
      { text: '評価ID', value: 't_assessment_id' },
      { text: 'ユーザID', value: 't_user_id' },
      { text: 'サンプルID', value: 'file_number' },
      { text: '評価値', value: 'score' },
      { text: '理由1位', value: 'reason_first' },
      { text: '理由2位', value: 'reason_second' },
      { text: 'コメント', value: 'comment' },
      { text: '作成日時', value: 'updated_at' },
    ],
    loading: true,
    assessments: [],
    all_data_count: 0,
    exp_ids: [],
    assess_ids: [],
    user_ids: [],
    search_exp_id: null,
    search_assess_id: null,
    search_user_id: null,
    options: {},
  }),

  watch: {
    options: {
      handler() {
        this.searchData()
      },
      deep: true,
    },
  },

  mounted() {
    this.reloadData()
  },

  methods: {
    reloadData() {
      const { sortBy, sortDesc, page, itemsPerPage } = this.options
      AssessmentApi.searchAssessments({
        limit: itemsPerPage,
        page: page,
      }).then((res) => {
        this.assessments = res.data
        this.all_data_count = res.count
        this.exp_ids = res.exp_ids
        this.assess_ids = res.assess_ids
        this.user_ids = res.user_ids
        this.loading = false
      })
    },

    searchData() {
      const { sortBy, sortDesc, page, itemsPerPage } = this.options
      AssessmentApi.searchAssessments({
        t_experiment_id: this.search_exp_id,
        t_assessment_id: this.search_assess_id,
        t_user_id: this.search_user_id,
        limit: itemsPerPage,
        page: page,
      }).then((res) => {
        this.assessments = res.data
        this.all_data_count = res.count
        this.exp_ids = res.exp_ids
        this.assess_ids = res.assess_ids
        this.user_ids = res.user_ids
        this.loading = false
      })
    },

    reset() {
      this.search_exp_id = null
      this.search_assess_id = null
      this.search_user_id = null
      this.reloadData()
    },

    downloadCSV() {
      AssessmentApi.searchAssessments({
        t_experiment_id: this.search_exp_id,
        t_assessment_id: this.search_assess_id,
        t_user_id: this.search_user_id,
      }).then((res) => {
        let assessments = res.data
        var csv =
          '\ufeff' +
          '実験ID,実験名,評価ID,ユーザID,サンプルID,評価値,理由1位,理由2位,コメント,作成日時\n'
        assessments.forEach((el) => {
          var line =
            el['t_experiment_id'] +
            ',' +
            this.escapeForCSV(el['name']) +
            ',' +
            el['t_assessment_id'] +
            ',' +
            el['t_user_id'] +
            ',' +
            el['file_number'] +
            ',' +
            el['score'] +
            ',' +
            el['reason_first'] +
            ',' +
            el['reason_second'] +
            ',' +
            this.escapeForCSV(el['comment']) +
            ',' +
            new Date(el['updated_at']).toLocaleString() +
            '\n'
          csv += line
        })
        let blob = new Blob([csv], { type: 'text/csv' })
        let link = document.createElement('a')
        link.href = window.URL.createObjectURL(blob)
        link.download = 'assessment_list.csv'
        link.click()
      })
    },

    escapeForCSV(s) {
      return `"${s.replace(/\"/g, '""')}"`
    },

    distinct(fieldNames) {
      var self = this
      return function (item, i, arr) {
        return i == indexOf(arr, item, equalsAllFields)
      }

      // arrのなかにobjが含まれていればそのインデックス番号を返す
      // 探し方はcomparatorを使って探す
      function indexOf(arr, obj, comparator) {
        for (var index in arr) {
          if (comparator(obj, arr[index]) == true) return index
        }
        return -1
      }

      // オブジェクトaとbが fieldNamesに当てられたプロパティーを比較して同じであればtrueを返す
      function equalsAllFields(a, b) {
        for (var i in fieldNames) {
          var f = fieldNames[i]
          if (a[f] !== b[f]) return false
        }
        return true
      }
    },
  },
}
</script>
