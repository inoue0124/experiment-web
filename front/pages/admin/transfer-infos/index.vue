<template>
  <v-data-table
    :headers="headers"
    :items="transfer_files"
    class="elevation-1 my-16"
  >

    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>振込情報ファイル一覧</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn
          color="primary"
          class="mb-2 mr-2"
          @click="downloadZip()"
        >
          Zipダウンロード
        </v-btn>
      </v-toolbar>
    </template>

    <template v-slot:[`item.last_modified`]="{ item }">
      <span>{{ new Date(item.last_modified).toLocaleString() }}</span>
    </template>

    <template v-slot:[`item.actions`]="{ item }">
      <v-icon small class="mr-2" @click="downloadFile(item)">mdi-download</v-icon>
    </template>

    <template v-slot:no-data>
      データがありません
    </template>
  </v-data-table>
</template>

<script>
import FacesheetApi from '@/plugins/axios/modules/facesheet'
import AwsApi from '@/plugins/axios/modules/aws'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',
  
  data: () => ({
    headers: [
      { text: 'ファイル名', value: 'key' },
      { text: '作成日時', value: 'last_modified'},
      { text: '操作', value: 'actions', sortable: false }
    ],
    transfer_files: []
  }),

  mounted () {
    this.reloadData()
  },

  methods: {
    reloadData() {
      AwsApi.listUndisclosedFiles("transfer").then((res) => {
        this.transfer_files = res
      })
    },
    downloadFile(item) {
      AwsApi.downloadFile(false, item.key, item.key.split('/').slice(-1)[0], item.key.split('.').slice(-1)[0]).then((res)=>{
        let link = document.createElement('a')
        link.href = window.URL.createObjectURL(res)
        link.download = item.key.split('/').slice(-1)[0]
        link.click()
      })
    },
    downloadZip () {
      AwsApi.downloadZipFile("transfer").then((res) => {
        let link = document.createElement('a')
        link.href = window.URL.createObjectURL(res)
        link.download = 'transfer_info.zip'
        link.click()
      })
    }
  },
}
</script>