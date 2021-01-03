<template>
  <v-data-table
    :headers="headers"
    :items="experiments"
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

    <template v-slot:[`item.actions`]="{ item }">
      <v-icon small class="mr-2" @click="toEdit(item)">mdi-pencil</v-icon>
    </template>

    <template v-slot:no-data>
      データがありません
    </template>
  </v-data-table>
</template>

<script>
import ExperimentApi from '@/plugins/axios/modules/experiment'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',
  
  data: () => ({
    headers: [
      { text: '実験ID', value: 'id'},
      { text: '実験名', value: 'name' },
      { text: '評価ID', value: 't_assessment_id' },
      { text: 'ユーザID', value: 't_user_id' },
      { text: 'サンプルID', value: 'file_number' },
      { text: '評価値', value: 'score' },
      { text: 'コメント', value: 'comment' },
      { text: '作成日時', value: 'updated_at'},
    ],
    experiments: []
  }),

  mounted () {
    this.reloadData()
  },

  methods: {
    reloadData() {
      ExperimentApi.searchExperiments().then((res) => {
        this.experiments = res
      })
    },

    downloadCSV () {
      var csv = '\ufeff' + '実験ID,実験名,評価ID,ユーザID,サンプルID,評価値,コメント,更新日時\n'
      this.experiments.forEach(el => {
        var line = el['id'] + ',' + el['name'] + ',' + el['t_assessment_id'] + ',' +
        el['t_user_id'] + ',' + el['file_number'] + ',' + el['score'] + ',' + el['comment']
         + ',' +el['updated_at'] + ',' + el['created_at'] + '\n'
        csv += line
      })
      let blob = new Blob([csv], { type: 'text/csv' })
      let link = document.createElement('a')
      link.href = window.URL.createObjectURL(blob)
      link.download = 'experiment_list.csv'
      link.click()
    }
  },
}
</script>