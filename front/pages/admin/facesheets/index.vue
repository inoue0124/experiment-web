<template>
  <v-data-table
    :headers="headers"
    :items="facesheets"
    class="elevation-1 my-16"
  >

    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>フェイスシート一覧</v-toolbar-title>
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
import FacesheetApi from '@/plugins/axios/modules/facesheet'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',
  
  data: () => ({
    headers: [
      { text: 'ユーザID', value: 't_user_id' },
      { text: '名前', value: 'name' },
      { text: '電話番号', value: 'phone' },
      { text: '作成日時', value: 'created_at'}
    ],
    facesheets: []
  }),

  mounted () {
    this.reloadData()
  },

  methods: {
    reloadData() {
      FacesheetApi.listDFacesheets().then((res) => {
        this.facesheets = res
      })
    },

    downloadCSV () {
      var csv = '\ufeff' + 'ユーザID,名前,電話番号,更新日時,作成日時\n'
      this.facesheets.forEach(el => {
        var line = el['t_user_id'] + ',' +el['name'] + ',' + el['phone'] + ',' + el['updated_at'] + ',' + el['created_at'] + '\n'
        csv += line
      })
      let blob = new Blob([csv], { type: 'text/csv' })
      let link = document.createElement('a')
      link.href = window.URL.createObjectURL(blob)
      link.download = 'facesheet_list.csv'
      link.click()
    }
  },
}
</script>