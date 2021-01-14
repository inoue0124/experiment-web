<template>
  <v-data-table
    :headers="headers"
    :items="assessments"
    class="elevation-1 my-16"
  >
    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>評価結果一覧</v-toolbar-title>
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
    assessments: []
  }),

  mounted () {
    this.reloadData()
  },

  methods: {
    reloadData() {
      AssessmentApi.searchAssessments().then((res) => {
        this.assessments = res
      })
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
    }
  },
}
</script>