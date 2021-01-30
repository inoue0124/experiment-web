<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="10">
      
      <v-row justify="center">
        <v-col cols="8" align="center">
          <StepProgress class="mb-10"></StepProgress>
        </v-col>
      </v-row>

      <h1 align="center" class="mb-16">評価内容説明</h1>

      <v-row justify="center">
        <v-col class="pa-0" cols="9">
          <PdfViewer class="mb-4 sticky" :pdf_url="pdf_url"></PdfViewer>
        </v-col>
      </v-row>

      <div align="center" class="mt-10">
        <v-btn color="primary" @click="next">次へ進む</v-btn>
      </div>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import InstructionApi from '@/plugins/axios/modules/instruction'
import PdfViewer from "@/components/PdfViewer"

export default {
  middleware: 'redirector',

  components: {
    PdfViewer
  },
  
  data() {
    return {
      pdf_url: null
    }
  },

  mounted() {
    this.getInstructionData()
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
    getInstructionData() {
      InstructionApi.getInstruction(this.$route.params.id).then((res) => {
        this.pdf_url = res.pdf_url
      })
    }
  }
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