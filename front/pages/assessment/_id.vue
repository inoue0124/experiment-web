<template>
  <v-col cols="12">
    <v-row justify="center">
      <v-col cols="7" align="center">
        <StepProgress class="mb-10"></StepProgress>
      </v-col>
    </v-row>

    <h1 align="center" class="mb-16">評価実験</h1>

    <v-row justify="center">
      <v-col v-if="instruction_file_url.includes('pdf')" class="pa-0" cols="10">
        <PdfViewer
          class="mb-4 sticky"
          :pdf_url="instruction_file_url"
        ></PdfViewer>
      </v-col>
      <v-col v-else class="pa-0 text-center" cols="10">
        <img class="mb-4 sticky" :src="instruction_file_url" />
      </v-col>
    </v-row>

    <v-row
      class="mb-10"
      justify="center"
      v-if="t_assessment.is_practice === false && test_url !== null"
    >
      <v-col cols="12" style="text-align: center">
        <div>テストの音声</div>
        <audio controls　controlslist="nodownload">
          <source :src="test_url" />
        </audio>
      </v-col>
    </v-row>

    {{ test_url }}

    <v-row
      justify="center"
      v-sticky="{ zIndex: 100, stickyTop: 0, disabled: false }"
    >
      <v-col v-if="rubric_file_url.includes('pdf')" class="pa-0" cols="8">
        <PdfViewer class="mb-4 sticky" :pdf_url="rubric_file_url"></PdfViewer>
      </v-col>
      <v-col v-else class="pa-0 text-center" cols="10">
        <img class="mb-4 sticky" :src="rubric_file_url" />
      </v-col>
    </v-row>

    <v-simple-table>
      <template v-slot:default>
        <tbody>
          <tr v-for="item in samples" :key="item.file_number" align="center">
            <td>
              <span v-if="t_assessment.is_practice === true">レベル</span>
              {{ item.file_number }}
            </td>
            <td>
              <audio controls　controlslist="nodownload">
                <source :src="item.url" />
              </audio>
            </td>

            <!-- 再実験の時はスコアだけ -->
            <div v-if="t_assessment.is_second_time">
              <td v-if="t_assessment.is_practice === false">
                <v-radio-group v-model="item.score" row>
                  <div v-for="val in t_assessment.point" :key="val">
                    <div>
                      {{ criteria[val - 1] ? criteria[val - 1] : '・' }}
                    </div>
                    <v-radio class="mr-10" :value="val"></v-radio>
                  </div>
                </v-radio-group>
              </td>
            </div>

            <div v-else>
              <td v-if="t_assessment.is_practice === false">
                <v-radio-group v-model="item.score" row>
                  <div v-for="val in t_assessment.point" :key="val">
                    <v-radio
                      :value="val"
                      :label="criteria[val - 1] ? criteria[val - 1] : '・'"
                    ></v-radio>
                  </div>
                </v-radio-group>

                <v-radio-group v-model="item.reason_first" row>
                  <span class="mr-5">1位</span>
                  <div v-for="val in reasons.length" :key="val">
                    <v-radio
                      :value="reasons[val - 1]"
                      :label="reasons[val - 1]"
                    ></v-radio>
                  </div>
                </v-radio-group>

                <v-radio-group v-model="item.reason_second" row>
                  <span class="mr-5">2位</span>
                  <div v-for="val in reasons.length" :key="val">
                    <v-radio
                      :value="reasons[val - 1]"
                      :label="reasons[val - 1]"
                    ></v-radio>
                  </div>
                </v-radio-group>

                <v-textarea
                  auto-grow
                  v-model="item.comment"
                  label="コメント"
                  outlined
                  class="vtextarea"
                  v-if="t_assessment.is_practice === false"
                ></v-textarea>
              </td>
            </div>
          </tr>
        </tbody>
      </template>
    </v-simple-table>

    <div align="center" class="mt-10">
      <v-btn color="primary" @click="prev">前へ戻る</v-btn>
      <v-btn color="primary" @click="next">次へ進む</v-btn>
    </div>
  </v-col>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import AwsApi from '@/plugins/axios/modules/aws'
import AssessmentApi from '@/plugins/axios/modules/assessment'
import PdfViewer from '@/components/PdfViewer'
import VueSticky from 'vue-sticky'

export default {
  middleware: 'redirector',

  components: {
    PdfViewer,
  },

  directives: {
    sticky: VueSticky,
  },

  data() {
    return {
      t_assessment: {},
      instruction_file_url: '',
      rubric_file_url: '',
      test_url: null,
      criteria: null,
      reasons: [
        '流暢さ',
        '正確さ',
        'テキスト',
        '伝わり具合',
        '豊かさ',
        '対人配慮',
      ],
      samples: null,
      autoSaveTimer: null,
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
        AssessmentApi.updateAssessmentData(
          this.$route.params.id,
          this.samples
        ).then((res) => {
          // スコアが0のときバリデーションエラーにする
          let isValid = true
          this.samples.forEach((item) => {
            if (this.t_assessment.is_second_time) {
              if (item.score === 0) {
                isValid = false
              }
            } else {
              if (
                item.score === 0 ||
                item.reason_first === '' ||
                item.reason_second === ''
              ) {
                isValid = false
              }
            }
          })
          if (!isValid) {
            alert('すべての音声のレベルを判定して下さい。')
            return
          }
          WorkflowApi.complete(this.$route.params.id).then((res) => {
            clearInterval(this.autoSaveTimer)
            this.$router.push(
              `/${res.work.name.toLowerCase()}/${res.workflow.id}`
            )
          })
        })
      } else {
        WorkflowApi.complete(this.$route.params.id).then((res) => {
          this.$router.push(
            `/${res.work.name.toLowerCase()}/${res.workflow.id}`
          )
        })
      }
    },
    prev() {
      // 本番の時はデータを更新
      if (this.t_assessment.is_practice === false) {
        AssessmentApi.updateAssessmentData(
          this.$route.params.id,
          this.samples
        ).then((res) => {
          WorkflowApi.undo().then((res) => {
            clearInterval(this.autoSaveTimer)
            this.$router.push(
              `/${res.work.name.toLowerCase()}/${res.workflow.id}`
            )
          })
        })
      } else {
        WorkflowApi.undo().then((res) => {
          this.$router.push(
            `/${res.work.name.toLowerCase()}/${res.workflow.id}`
          )
        })
      }
    },
    getAssessmentData() {
      AwsApi.listDisclosedFiles('assessment/' + this.$route.params.id).then(
        (res) => {
          console.log(res)
          let instructionKey = res.find((r) => r.key.includes('instruction'))
            .key
          this.instruction_file_url =
            'https://s3-ap-northeast-1.amazonaws.com/disclose.experiment-web/' +
            instructionKey
          let rubricKey = res.find((r) => r.key.includes('rubric')).key
          this.rubric_file_url =
            'https://s3-ap-northeast-1.amazonaws.com/disclose.experiment-web/' +
            rubricKey
        }
      )
      AssessmentApi.getAssessment(this.$route.params.id).then((res) => {
        this.t_assessment = res.t_assessment
        this.criteria = this.t_assessment.criteria.split(',')
        this.reasons = this.t_assessment.reasons.split(',')

        fetch(res.test_url).then((r) => {
          if (r.status === 200) {
            this.test_url = res.test_url
          } else {
            this.test_url = null
          }
        })

        AssessmentApi.getAssessmentData(this.$route.params.id).then((res) => {
          this.samples = res
        })

        // 本番の時はデータを取得
        if (this.t_assessment.is_practice === false) {
          this.autoSaveTimer = setInterval(() => {
            AssessmentApi.updateAssessmentData(
              this.$route.params.id,
              this.samples
            )
          }, 10000)
        }
      })
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
.v-messages {
  min-height: 0;
}
</style>
