<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="12" sm="8" md="6" align="center">
      <h1 class="mb-16">振り込み情報</h1>

      <p>以下のファイルをダウンロードし、必要事項を記入の上アップロードしてください。</p>
      <v-btn color="success" @click="downloadExcel">ファイルダウンロード</v-btn>

      <p class="mt-16" align="left">支払い調書アップロード</p>
      
      <ClientFileUploader 
        :file_key="'transfer/' + $route.params.id + '/transfer-information/' + user_id + '.xlsx'"
        file_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      ></ClientFileUploader>


      <p class="mt-16" align="left">銀行振込情報アップロード</p>
      
      <ClientFileUploader 
        :file_key="'transfer/' + $route.params.id + '/transfer-signature/' + user_id + '.xlsx'"
        file_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      ></ClientFileUploader>

      <v-btn color="primary" @click="next">次へ進む</v-btn>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import AwsApi from '@/plugins/axios/modules/aws'
import SessionApi from '@/plugins/axios/modules/session'
import ClientFileUploader from '@/components/ClientFileUploader'

export default {
  middleware: 'redirector',

  data() {
    return {
      user_id: null
    }
  },

  mounted() {
    SessionApi.getCurrentUser().then((res) =>{
      this.user_id = res.data.id
    })
  },

  methods: {
    downloadExcel() {
      AwsApi.downloadFile('transfer/transfer_signature.xlsx', 'transfer_signature.xlsx', 'xlsx').then((res)=>{
        let link = document.createElement('a')
        link.href = window.URL.createObjectURL(res)
        link.download = '支払い調書.xlsx'
        link.click()
      })
      AwsApi.downloadFile('transfer/transfer_information.xlsx', 'transfer_information.xlsx', 'xlsx').then((res)=>{
        let link = document.createElement('a')
        link.href = window.URL.createObjectURL(res)
        link.download = '振込先情報.xlsx'
        link.click()
      })
    },
    next() {
      WorkflowApi.complete(this.$route.params.id).then((res) => {
        this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
      })
    }
  }
}
</script>