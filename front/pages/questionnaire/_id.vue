<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="12" sm="8" md="6">
      <StepProgress class="mb-10"></StepProgress>

      <h1 align="center" class="mb-16">アンケート</h1>

      <v-alert
        type="info"
        outlined
        class="mb-4"
      >
        フォーム画面が表示されるまでに少し時間がかかりますので、お待ちください。
      </v-alert>

      <iframe
        :src="`${form_url}`"
        width="100%" height="500" frameborder="0" marginheight="0" marginwidth="0"
        @load="onIframeLoad"
      >
        読み込んでいます…
      </iframe>

      <ConfirmDialog
        ref="confirm"
        title="回答済み確認"
        message="アンケートの送信を完了しましたか？"
        buttonMessage="完了した"
        @confirm="confirmProceed"
        color="primary"
      >
      </ConfirmDialog>

      <div align="center">
        <v-btn v-if="!isFirstWorkflow" color="primary" @click="prev">前へ戻る</v-btn>
        <v-btn color="primary" @click="next" :disabled="isLoading">次へ進む</v-btn>
      </div>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import QuestionnaireApi from '@/plugins/axios/modules/questionnaire'
import ConfirmDialog from '@/components/dialogs/ConfirmDialog'
import StepProgress from '@/components/StepProgress'

export default {
  middleware: 'redirector',

  components: {
    ConfirmDialog,
    StepProgress
  },

  data() {
    return {
      form_url: "",
      isLoading: true,
      isFirstWorkflow: false
    }
  },

  mounted() {
    QuestionnaireApi.getQuestionnaire(this.$route.params.id).then((res) => {
      this.form_url = res.url
    })

    // 最初のワークフローかどうかをチェック
    WorkflowApi.getWork().then((res) => {
      this.isFirstWorkflow = res.is_first_workflow || false
    })
  },

  methods: {
    next() {
      this.$refs.confirm.open()
    },
    confirmProceed () {
      WorkflowApi.complete(this.$route.params.id).then((res) => {
        this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
      })
    },
    onIframeLoad() {
      this.isLoading = false
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
    }
  }
}
</script>
