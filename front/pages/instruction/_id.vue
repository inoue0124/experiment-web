<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="10">
      <v-row justify="center">
        <v-col cols="8" align="center">
          <StepProgress class="mb-10"></StepProgress>
        </v-col>
      </v-row>

      <h1 align="center" class="mb-16">実験概要説明</h1>

      <v-row justify="center">
        <v-col
          v-if="instruction_file_url.includes('pdf')"
          class="pa-0"
          cols="12"
        >
          <PdfViewer
            class="mb-4 sticky"
            :pdf_url="instruction_file_url"
          ></PdfViewer>
        </v-col>
        <v-col v-else class="pa-0 text-center" cols="12">
          <img class="mb-4 sticky" :src="instruction_file_url" />
        </v-col>
      </v-row>

      <div align="center" class="mt-10">
        <v-btn v-if="!isFirstWorkflow" color="primary" @click="prev">前へ戻る</v-btn>
        <v-btn color="primary" @click="next">次へ進む</v-btn>
      </div>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import AwsApi from '@/plugins/axios/modules/aws'
import PdfViewer from '@/components/PdfViewer'

export default {
  middleware: 'redirector',

  components: {
    PdfViewer,
  },

  data() {
    return {
      instruction_file_url: '',
      isFirstWorkflow: false
    }
  },

  mounted() {
    this.getInstructionData()
    
    // 最初のワークフローかどうかをチェック
    WorkflowApi.getWork().then((res) => {
      this.isFirstWorkflow = res.is_first_workflow || false
    })
  },

  destroyed() {
    clearInterval(this.autoSaveTimer)
  },

  methods: {
    next() {
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
    getInstructionData() {
      AwsApi.listDisclosedFiles('instruction/' + this.$route.params.id).then(
        (res) => {
          // this.files = res
          let key = res.find((r) => r.key.includes('instruction')).key
          this.instruction_file_url =
            'https://s3-ap-northeast-1.amazonaws.com/disclose.experiment-web/' +
            key
        }
      )
    },
  },
}
</script>

<style lang="scss">
td {
  background: #f0f8ff;
  border-bottom: none !important;
  padding: 0px !important;
}
tr:nth-child(odd) td {
  background: #fff;
  padding: 0px;
}
.vtextarea {
  min-width: 300px;
  padding-top: 30px !important;
}
</style>
