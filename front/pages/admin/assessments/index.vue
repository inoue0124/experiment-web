<template>
  <v-data-table
    :headers="headers"
    :items="assessments"
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
            class="mx-2"
            @input="searchData()"
          ></v-select>
        </v-col>
        <v-col cols="9" sm="2" md="2">
          <v-select
            label="評価ID"
            :items="assess_ids"
            v-model="search_assess_id"
            class="mx-2"
            @input="searchData()"
          ></v-select>
        </v-col>
        <v-col cols="9" sm="2" md="2">
          <v-select
            label="ユーザID"
            :items="user_ids"
            v-model="search_user_id"
            class="mx-2"
            @input="searchData()"
          ></v-select>
        </v-col>
        <v-btn
          class="mb-2 mr-2"
          @click="reset()"
          outlined
        >
          リセット
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn
          color="primary"
          class="mb-2 mr-2"
          @click="downloadCSV()"
        >
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

    <template v-slot:no-data>
      データがありません
    </template>
  </v-data-table>
</template>

<script>
import AssessmentApi from '@/plugins/axios/modules/assessment'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',
  
  data: () => ({
    headers: [
      { text: '実験ID', value: 't_experiment_id'},
      { text: '実験名', value: 'name' },
      { text: '評価ID', value: 't_assessment_id' },
      { text: '練習かどうか', value: 'is_practice' },
      { text: 'ユーザID', value: 't_user_id' },
      { text: 'サンプルID', value: 'file_number' },
      { text: '評価値', value: 'score' },
      { text: 'コメント', value: 'comment' },
      { text: '作成日時', value: 'updated_at'},
    ],
    assessments: [],
    exp_ids: [],
    assess_ids: [],
    user_ids: [],
    search_exp_id: null,
    search_assess_id: null,
    search_user_id: null
  }),

  mounted () {
    this.reloadData()
  },

  methods: {
    reloadData() {
      AssessmentApi.searchAssessments().then((res) => {
        this.assessments = res
        this.exp_ids = res.filter(this.distinct(['t_experiment_id'])).map(elm => elm.t_experiment_id)
        this.assess_ids = res.filter(this.distinct(['t_assessment_id'])).map(elm => elm.t_assessment_id)
        this.user_ids = res.filter(this.distinct(['t_user_id'])).map(elm => elm.t_user_id)
      })
    },

    searchData() {
      AssessmentApi.searchAssessments(
        {
          t_experiment_id: this.search_exp_id,
          t_assessment_id: this.search_assess_id,
          t_user_id: this.search_user_id
        })
      .then((res) => {
        this.assessments = res
      })
    },

    reset() {
      this.search_exp_id = null
      this.search_assess_id = null
      this.search_user_id = null
      this.reloadData()
    },

    downloadCSV () {
      var csv = '\ufeff' + '実験ID,実験名,評価ID,練習かどうか,ユーザID,サンプルID,評価値,コメント,作成日時\n'
      this.assessments.forEach(el => {
        var line = el['t_experiment_id'] + ',' + el['name'] + ',' + el['t_assessment_id'] + ',' + el['is_practice'] + ',' +
        el['t_user_id'] + ',' + el['file_number'] + ',' + el['score'] + ',' + el['comment']
         + ',' + new Date(el['updated_at']).toLocaleString() + '\n'
        csv += line
      })
      let blob = new Blob([csv], { type: 'text/csv' })
      let link = document.createElement('a')
      link.href = window.URL.createObjectURL(blob)
      link.download = 'assessment_list.csv'
      link.click()
    },

    distinct(fieldNames) {
      var self = this;
      return function(item, i, arr) {
        return i == indexOf(arr, item, equalsAllFields)
      }

      // arrのなかにobjが含まれていればそのインデックス番号を返す
      // 探し方はcomparatorを使って探す
      function indexOf(arr, obj, comparator) {
        for(var index in arr) {
          if(comparator(obj, arr[index]) == true) return index;
        }
        return -1;
      }

      // オブジェクトaとbが fieldNamesに当てられたプロパティーを比較して同じであればtrueを返す
      function equalsAllFields(a, b) {
        for(var i in fieldNames) {
          var f = fieldNames[i];
          if(a[f] !== b[f]) return false;
        }
        return true;
      }
    }
  },
}
</script>