<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="12" sm="8" md="6" align="center">
      <StepProgress class="mb-10"></StepProgress>

      <h1 class="mb-16">振り込み情報</h1>

      <p style="text-align: left">
        謝金のお振込に必要な以下の支払い調書、振込先情報ファイルをダウンロードし、必要事項を記入の上アップロードしてください。(ファイル名は変更しないで下さい。ファイル名は、「支払い調書.xlsx」と「振込先情報.xlsx」です。)
      </p>

      <h3 class="mt-16" align="left">支払い調書</h3>
      <v-btn class="my-4" color="success" @click="downloadTransferSig"
        >支払い調書ファイルダウンロード<v-icon
          small
          class="mr-2"
          @click="downloadFile(item)"
          >mdi-download</v-icon
        ></v-btn
      >
      <ClientFileUploader
        ref="transferSig"
        :file_key="`transfer/transfer-signature/exp${user.t_experiment_id}_user${user.id}.xlsx`"
        file_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        file_name="支払い調書.xlsx"
      ></ClientFileUploader>

      <div v-if="!isSecondTime">
        <h3 class="mt-16" align="left">振込先情報</h3>
        <v-btn class="my-4" color="success" @click="downloadTransferInf"
          >振込先情報ファイルダウンロード<v-icon
            small
            class="mr-2"
            @click="downloadFile(item)"
            >mdi-download</v-icon
          ></v-btn
        >
        <ClientFileUploader
          ref="transferInf"
          :file_key="`transfer/transfer-information/exp${user.t_experiment_id}_user${user.id}.xlsx`"
          file_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          file_name="振込先情報.xlsx"
        ></ClientFileUploader>
      </div>

      <v-btn v-if="!isFirstWorkflow" color="primary" @click="prev">前へ戻る</v-btn>
      <v-btn color="primary" @click="next">次へ進む</v-btn>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import AwsApi from '@/plugins/axios/modules/aws'
import SessionApi from '@/plugins/axios/modules/session'
import TransferApi from '@/plugins/axios/modules/transfer'
import ConfirmDialog from '@/components/dialogs/ConfirmDialog'

export default {
  middleware: 'redirector',

  components: {
    ConfirmDialog,
  },

  data() {
    return {
      user: {},
      isSecondTime: false,
      isFirstWorkflow: false
    }
  },

  mounted() {
    SessionApi.getCurrentUser().then((res) => {
      this.user = res.data
    })
    TransferApi.getTransfer(this.$route.params.id).then((res) => {
      if (res) {
        this.isSecondTime = res.is_second_time
      }
    })

    // 最初のワークフローかどうかをチェック
    WorkflowApi.getWork().then((res) => {
      this.isFirstWorkflow = res.is_first_workflow || false
    })
  },

  methods: {
    downloadTransferSig() {
      let file_key
      if (this.isSecondTime) {
        file_key = 'transfer/transfer_signature2.xlsx'
      } else {
        file_key = 'transfer/transfer_signature.xlsx'
      }
      AwsApi.downloadFile(
        true,
        file_key,
        'transfer_signature.xlsx',
        'xlsx'
      ).then((res) => {
        let link = document.createElement('a')
        link.href = window.URL.createObjectURL(res)
        link.download = '支払い調書.xlsx'
        link.click()
      })
    },
    downloadTransferInf() {
      AwsApi.downloadFile(
        true,
        'transfer/transfer_information.xlsx',
        'transfer_information.xlsx',
        'xlsx'
      ).then((res) => {
        let link = document.createElement('a')
        link.href = window.URL.createObjectURL(res)
        link.download = '振込先情報.xlsx'
        link.click()
      })
    },
    next() {
      if (!this.$refs.transferSig.currentFile) {
        alert('支払調書ファイルをアップロードして下さい！')
        return
      }
      if (!this.isSecondTime && !this.$refs.transferInf.currentFile) {
        alert('振込先情報ファイルをアップロードして下さい！')
        return
      }
      WorkflowApi.complete(this.$route.params.id).then((res) => {
        this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
      })
    },
    prev() {
      WorkflowApi.undo().then((res) => {
        this.$router.push(
          `/${res.work.name.toLowerCase()}/${res.workflow.id}`
        )
      }).catch((error) => {
        if (error.response && error.response.data && error.response.data.error) {
          alert(error.response.data.error)
        } else {
          alert('エラーが発生しました')
        }
      })
    },
  },
}
</script>
