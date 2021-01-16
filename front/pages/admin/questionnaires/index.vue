<template>
  <v-data-table
    :headers="headers"
    :items="questionnaires"
    class="elevation-1 my-16"
  >

    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>アンケート一覧</v-toolbar-title>
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

    <template v-slot:[`item.url`]="{ item }">
      <a :href="item.url" target="_blank">{{item.url}}</a>
    </template>

    <template v-slot:[`item.updated_at`]="{ item }">
      <span>{{ new Date(item.updated_at).toLocaleString() }}</span>
    </template>

    <template v-slot:[`item.created_at`]="{ item }">
      <span>{{ new Date(item.created_at).toLocaleString() }}</span>
    </template>

    <template v-slot:no-data>
      データがありません
    </template>
  </v-data-table>
</template>

<script>
import QuestionnaireApi from '@/plugins/axios/modules/questionnaire'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',
  
  data: () => ({
    headers: [
      { text: '実験ID', value: 't_experiment_id'},
      { text: '実験名', value: 'name' },
      { text: 'アンケートID', value: 'id' },
      { text: 'アンケートURL', value: 'url' },
      { text: '変更日時', value: 'updated_at'},
      { text: '作成日時', value: 'created_at'}
    ],
    questionnaires: [],
  }),

  mounted () {
    this.reloadData()
  },

  methods: {
    reloadData() {
      QuestionnaireApi.listQuestionnaires().then((res) => {
        this.questionnaires = res
      })
    },
    downloadCSV () {
      var csv = '\ufeff' + '実験ID,実験名,アンケートURL,変更日時,作成日時\n'
      this.questionnaires.forEach(el => {
        var line = el['id'] + ',' + el['name'] + ',' + el['url'] + ',' + new Date(el['updated_at']).toLocaleString() + ',' + new Date(el['created_at']).toLocaleString() + '\n'
        csv += line
      })
      let blob = new Blob([csv], { type: 'text/csv' })
      let link = document.createElement('a')
      link.href = window.URL.createObjectURL(blob)
      link.download = 'questionnaires_list.csv'
      link.click()
    }
  },
}
</script>