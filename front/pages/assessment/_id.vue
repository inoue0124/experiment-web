<template>
  <div>
    <!-- ヘッダー部分 -->
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
          <audio controls controlslist="nodownload">
            <source :src="test_url" />
          </audio>
        </v-col>
      </v-row>

      <!-- 使用方法の案内 -->
      <v-alert
        v-if="t_assessment.is_practice === false"
        type="info"
        outlined
        class="mb-4"
      >
        <div class="d-flex align-center">
          <span>
            左側にルーブリック、右側に評価フォームが表示されます。右側は下にスクロールして全ての項目を評価してください。
          </span>
        </div>
      </v-alert>
    </v-col>

    <!-- 練習モード：縦並び / 本番モード：左右分割 -->
    <div v-if="t_assessment.is_practice === true" class="practice-layout">
      <!-- ルーブリック（上） -->
      <div class="rubric-section">
        <div v-if="rubric_file_url.includes('pdf')" class="pa-2">
          <PdfViewer :pdf_url="rubric_file_url"></PdfViewer>
        </div>
        <div v-else class="pa-2 text-center">
          <img :src="rubric_file_url" style="max-width: 100%; height: auto;" />
        </div>
      </div>

      <!-- 評価フォーム（下） -->
      <div class="assessment-section">
        <div class="practice-audio-list">
          <div v-for="item in samples" :key="item.file_number" class="practice-item">
            <span class="practice-label">レベル {{ item.file_number }}</span>
            <audio controls controlslist="nodownload" class="practice-audio">
              <source :src="item.url" />
            </audio>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="full-width-layout">
      <div class="rubric-panel">
        <div class="sticky-rubric">
          <div v-if="rubric_file_url.includes('pdf')" class="pa-1">
            <PdfViewer :pdf_url="rubric_file_url"></PdfViewer>
          </div>
          <div v-else class="pa-1 text-center">
            <img :src="rubric_file_url" style="max-width: 100%; height: auto;" />
          </div>

          <!-- 練習音声参考エリア -->
          <div v-if="practiceData.length > 0" class="practice-reference">
            <h4 class="practice-title">ベンチマーク音声</h4>
            <div v-for="item in practiceData" :key="item.file_number" class="practice-item">
              <span class="practice-label">レベル {{ item.file_number }}</span>
              <audio controls controlslist="nodownload" class="practice-audio">
                <source :src="item.url" />
              </audio>
            </div>
          </div>
        </div>
      </div>

      <div class="assessment-panel">
        <v-simple-table>
      <template v-slot:default>
        <tbody>
          <tr v-for="item in samples" :key="item.file_number" align="center">
            <td>
              <span v-if="t_assessment.is_practice === true">レベル</span>
              {{ item.file_number }}
            </td>
            <td class="audio-cell">
              <audio controls controlslist="nodownload">
                <source :src="item.url" />
              </audio>
            </td>

            <!-- 再実験の時はスコアだけ -->
            <td v-if="t_assessment.is_second_time && t_assessment.is_practice === false">
              <v-radio-group v-model="item.score" row>
                <div v-for="val in t_assessment.point" :key="val" class="score-item">
                  <div class="score-label">
                    {{ criteria[val - 1] ? criteria[val - 1] : '・' }}
                  </div>
                  <v-radio class="mr-10" :value="val"></v-radio>
                </div>
              </v-radio-group>

              <!-- コメント欄 -->
              <v-textarea
                v-model="item.comment"
                label="コメント"
                outlined
                class="vtextarea"
                rows="3"
              ></v-textarea>
            </td>

            <td v-else-if="!t_assessment.is_second_time && t_assessment.is_practice === false">
              <v-radio-group v-model="item.score" row>
                <div v-for="val in t_assessment.point" :key="val" class="score-item">
                  <div class="score-label">
                    {{ criteria[val - 1] ? criteria[val - 1] : '・' }}
                  </div>
                  <v-radio :value="val"></v-radio>
                </div>
              </v-radio-group>

              <!-- コメント欄 -->
              <v-textarea
                v-model="item.comment"
                label="コメント"
                outlined
                class="vtextarea"
                rows="3"
              ></v-textarea>
            </td>
          </tr>
        </tbody>
      </template>
    </v-simple-table>
      </div>
    </div>

    <!-- ナビゲーションボタン -->
    <div align="center" class="mt-10">
      <v-btn color="primary" @click="prev">前へ戻る</v-btn>
      <v-btn color="primary" @click="next">次へ進む</v-btn>
    </div>
  </div>
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
      practiceData: [],
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
            if (item.score === 0) {
              isValid = false
            }
          })
          if (!isValid) {
            alert('すべての音声のレベルを判定して下さい。\n※右側の画面を下にスクロールして、すべての項目を確認してください。')
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
          // 練習データを取得
          AssessmentApi.getPracticeAssessmentData(this.$route.params.id).then((practiceRes) => {
            this.practiceData = practiceRes.practice_data
          })

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
  padding: 1px 4px !important;
  font-size: 0.9rem;
  line-height: 1.2;
}
tr:nth-child(odd) td {
  background: #fff;
  padding: 1px 4px !important;
}
.vtextarea {
  min-width: 200px;
  padding-top: 5px !important;
  margin-bottom: 3px !important;
  margin-right: 16px !important;
}
.v-messages {
  min-height: 0;
}
.v-radio-group {
  margin-bottom: 6px !important;
  margin-top: 2px !important;
}
.v-radio {
  margin-right: 1px !important;
  flex: 0 0 auto;
}
.v-application .mr-10 {
  margin-right: 2px !important;
}
.mr-5 {
  margin-right: 2px !important;
}
.v-radio-group--row .v-radio {
  margin-right: 1px !important;
}
.v-input {
  margin-bottom: 2px !important;
}
.v-input--radio-group .v-input__slot {
  margin-bottom: 0 !important;
}
.v-radio .v-label {
  font-size: 0.75rem !important;
  color: #555;
}
.v-radio .v-input--selection-controls__input {
  margin-right: 2px;
}
.score-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}
.score-label {
  text-align: center;
  margin-bottom: 2px;
}
.audio-cell {
  padding: 8px !important;
  width: 300px;
}
.practice-layout .v-simple-table {
  text-align: center;
}
.practice-layout td {
  text-align: center !important;
}
.practice-layout .audio-cell {
  width: auto !important;
}
.practice-layout td:first-child {
  width: 80px !important;
  padding-right: 4px !important;
}
.practice-layout .audio-cell {
  width: auto !important;
  padding-left: 4px !important;
}

/* 練習音声参考エリアのスタイル */
.practice-reference {
  border-top: 2px solid #e0e0e0;
  margin: 16px 8px 0 8px;
  padding: 16px;
}

.practice-title {
  font-size: 1rem;
  font-weight: 600;
  color: #424242;
  margin: 0 0 12px 0;
  padding: 4px 0;
  border-bottom: 1px solid #ddd;
}

.practice-item {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
  gap: 8px;
}

.practice-label {
  min-width: 70px;
  font-size: 0.9rem;
  color: #666;
  font-weight: 500;
}

.practice-audio {
  flex: 1;
  height: 32px;
}
.practice-audio-list {
  padding: 16px;
}
.full-width-layout {
  display: flex;
  width: 100vw;
  margin-left: calc(-50vw + 50%);
  height: 100vh;
}
.rubric-panel {
  width: 50%;
  border-right: 1px solid #ddd;
}
.sticky-rubric {
  position: sticky;
  top: 0;
  height: 100vh;
  overflow-y: auto;
}
.assessment-panel {
  width: 50%;
  height: 100vh;
  overflow-y: auto;
}
.practice-layout {
  display: flex;
  flex-direction: column;
}
.rubric-section {
  border-bottom: 2px solid #ddd;
  margin-bottom: 16px;
  padding-bottom: 16px;
}
.assessment-section {
  flex: 1;
}
.audio-form-cell {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  vertical-align: top !important;
  height: auto !important;
}
tr {
  height: auto !important;
}
tbody tr {
  height: auto !important;
}

</style>
