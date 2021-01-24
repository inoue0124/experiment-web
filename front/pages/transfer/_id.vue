<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="12" sm="8" md="6" align="center">
      <StepProgress class="mb-10"></StepProgress>

      <h1 class="mb-16">振り込み情報</h1>

      <p>振込に必要な以下の２つのファイル（支払い調書、振込先情報）をダウンロードし、必要事項を記入の上アップロードしてください。<br>(ファイル名は変更しないで下さい。)</p>

      <h3 class="mt-16" align="left">支払い調書</h3>
      <v-btn class="my-4" color="success" @click="downloadTransferSig">支払い調書ファイルダウンロード</v-btn>
      <ClientFileUploader 
        :file_key="`transfer/transfer-signature/exp${user.t_experiment_id}_user${user.id}.xlsx`"
        file_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        file_name="支払い調書.xlsx"
      ></ClientFileUploader>


      <h3 class="mt-16" align="left">振込先情報</h3>
      <v-btn class="my-4" color="success" @click="downloadTransferInf">振込先情報ファイルダウンロード</v-btn>
      <ClientFileUploader 
        :file_key="`transfer/transfer-information/exp${user.t_experiment_id}_user${user.id}.xlsx`"
        file_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        file_name="振込先情報.xlsx"
      ></ClientFileUploader>

      <ConfirmDialog
        ref="confirm"
        title="アップロード済み確認"
        message="ファイルをアップロードしましたか？"
        buttonMessage="アップロードした"
        @confirm="confirmProceed"
        color="primary"
      >
      </ConfirmDialog>

      <v-btn color="primary" @click="next">次へ進む</v-btn>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import AwsApi from '@/plugins/axios/modules/aws'
import SessionApi from '@/plugins/axios/modules/session'
import ClientFileUploader from '@/components/ClientFileUploader'
import ConfirmDialog from '@/components/dialogs/ConfirmDialog'
import StepProgress from '@/components/StepProgress'

export default {
  middleware: 'redirector',

  components: {
    ConfirmDialog
  },

  data() {
    return {
      user: {}
    }
  },

  mounted() {
    SessionApi.getCurrentUser().then((res) =>{
      this.user = res.data
    })
  },

  methods: {
    downloadTransferSig() {
      AwsApi.downloadFile(true, 'transfer/transfer_signature.xlsx', 'transfer_signature.xlsx', 'xlsx').then((res)=>{
        let link = document.createElement('a')
        link.href = window.URL.createObjectURL(res)
        link.download = '支払い調書.xlsx'
        link.click()
      })
    },
    downloadTransferInf() {
      AwsApi.downloadFile(true, 'transfer/transfer_information.xlsx', 'transfer_information.xlsx', 'xlsx').then((res)=>{
        let link = document.createElement('a')
        link.href = window.URL.createObjectURL(res)
        link.download = '振込先情報.xlsx'
        link.click()
      })
    },
    next() {
      this.$refs.confirm.open()
    },
    confirmProceed () {
      WorkflowApi.complete(this.$route.params.id).then((res) => {
        this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
      })
    }
  }
}
</script>