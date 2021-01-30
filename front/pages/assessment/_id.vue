<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="10">
      
      <v-row justify="center">
        <v-col cols="8" align="center">
          <StepProgress class="mb-10"></StepProgress>
        </v-col>
      </v-row>

      <h1 align="center" class="mb-16">評価実験</h1>

      <v-row justify="center">
        <v-col class="pa-0" cols="9">
          <PdfViewer class="mb-4 sticky" :pdf_url="instruction_pdf_url"></PdfViewer>
        </v-col>
      </v-row>

      <v-row class="mb-10" justify="center" v-if="t_assessment.is_practice === false">
        <v-col cols="12" style="text-align:center;">
          <div>テストの音声</div>
          <audio controls　controlslist="nodownload">
            <source :src="test_url">
          </audio>
        </v-col>
      </v-row>

      <v-row justify="center" v-sticky="{ zIndex: 100, stickyTop: 0, disabled: false}">
        <v-col class="pa-0" cols="9">
          <PdfViewer class="mb-4 sticky" :pdf_url="rubric_pdf_url"></PdfViewer>
        </v-col>
      </v-row>

      <v-simple-table>
        <template v-slot:default>
          <tbody>
            <tr
              v-for="item in samples"
              :key="item.file_number"
              align="center"
            >
              <td>
                <span v-if="t_assessment.is_practice === true">レベル</span>
                {{item.file_number}}
              </td>
              <td>
                <audio controls　controlslist="nodownload">
                  <source :src="item.url">
                </audio>
              </td>

              <td v-if="t_assessment.is_practice === false">
                <v-radio-group v-model="item.score" row>
                  <div v-for="val in t_assessment.point" :key="val">
                    <div>{{criteria[val-1] ? criteria[val-1] : "・"}}</div>
                    <v-radio :value=val></v-radio>
                  </div>
                </v-radio-group>
              </td>

              <td v-if="t_assessment.is_practice === false">
                <v-textarea
                  auto-grow
                  v-model="item.comment"
                  label="コメント"
                  outlined
                  class="vtextarea"
                ></v-textarea>
              </td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>

      <div align="center" class="mt-10">
        <v-btn color="primary" @click="prev">前へ戻る</v-btn>
        <v-btn color="primary" @click="next">次へ進む</v-btn>
      </div>

    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import AssessmentApi from '@/plugins/axios/modules/assessment'
import PdfViewer from "@/components/PdfViewer"
import VueSticky from 'vue-sticky'

export default {
  middleware: 'redirector',

  components: {
    PdfViewer
  },

  directives: {
    'sticky': VueSticky,
  },
  
  data() {
    return {
      t_assessment: {},
      instruction_pdf_url: null,
      rubric_pdf_url: null,
      test_url: null,
      criteria: null,
      samples: null,
      autoSaveTimer: null
    }
  },

  mounted() {
    this.getAssessmentData()
  },

  destroyed() {
    clearInterval(this.autoSaveTimer)
  },

  methods: {
    next() {
      // 本番の時はデータを保存
      if (this.t_assessment.is_practice === false) {
        AssessmentApi.updateAssessmentData(this.$route.params.id, this.samples).then((res) => {
          // スコアが0のときバリデーションエラーにする
          let isValid = true
          this.samples.forEach(item => {
            if (item.score===0) { isValid = false }
          })
          if (!isValid) {
            alert('すべての音声のレベルを判定して下さい。')
            return
          }
          WorkflowApi.complete(this.$route.params.id).then((res) => {
            this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
          })
        })
      } else {
        WorkflowApi.complete(this.$route.params.id).then((res) => {
          this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
        })
      }
    },
    prev() {
      // 本番の時はデータを更新
      if (this.t_assessment.is_practice === false) {
        AssessmentApi.updateAssessmentData(this.$route.params.id, this.samples).then((res) => {
          WorkflowApi.undo().then((res) => {
            this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
          })
        })
      } else {
        WorkflowApi.undo().then((res) => {
          this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
        })
      }
    },
    getAssessmentData() {
      AssessmentApi.getAssessment(this.$route.params.id).then((res) => {
        this.t_assessment = res.t_assessment
        this.instruction_pdf_url = res.instruction_pdf_url
        this.rubric_pdf_url = res.rubric_pdf_url
        this.test_url = res.test_url
        this.criteria = this.t_assessment.criteria.split(',')

        AssessmentApi.getAssessmentData(this.$route.params.id).then((res) => {
          this.samples = res
        })

        // 本番の時はデータを取得
        if (this.t_assessment.is_practice === false) {
          this.autoSaveTimer = setInterval(() => {
            AssessmentApi.updateAssessmentData(this.$route.params.id, this.samples)
          }, 10000)
        }
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