<template>
  <v-dialog
      v-model="dialog"
      fullscreen
      hide-overlay
      transition="dialog-bottom-transition"
    >
    <v-card class="ma-0 pa-0">
      <v-container fluid class="pa-0">
        <v-row class="pa-0">
          <v-col class="pa-10 ma-0" cols="12" sm="9" md="9">
            <v-toolbar flat>
              <v-btn icon @click="openConfirmDiscardDialog">
                <v-icon>mdi-close</v-icon>
              </v-btn>
              <span class="headline">新規実験作成</span>
            </v-toolbar>

            <v-card-text class="pa-10">
              <p class="mb-3 mx-10 card-title">実験名設定</p>
              <v-card class="mx-10 pa-5 mb-16">
                <v-card-text>
                  <v-text-field
                    label="実験名"
                    v-model="name"
                    required
                  ></v-text-field>
                </v-card-text>
              </v-card>

              <div v-for="(work, key) in workflow" :key="key">
                <div v-if="work=='agreement'">
                  <p class="mb-3 mx-10 card-title">同意書設定</p>
                  <RegisterAgreementCard class="mx-10 pa-5 mb-16" ref="agreement"></RegisterAgreementCard>
                </div>
                
                <div v-if="work=='facesheet'">
                  <p class="mb-3 mx-10 card-title">フェイスシート設定</p>
                  <RegisterFacesheetCard class="mx-10 pa-5 mb-16" ref="facesheet"></RegisterFacesheetCard>
                </div>

                <div v-if="work=='assessment'">
                  <p class="mb-3 mx-10 card-title">評価実験設定</p>
                  <RegisterAssessmentCard class="mx-10 pa-5 mb-16" ref="assessment"></RegisterAssessmentCard>
                </div>
                
                <div v-if="work=='questionnaire'">
                  <p class="mb-3 mx-10 card-title">アンケート設定</p>
                  <RegisterQuestionnaireCard class="mx-10 pa-5 mb-16" ref="questionnaire"></RegisterQuestionnaireCard>
                </div>
              </div>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="error" @click="openConfirmDiscardDialog">破棄</v-btn>
              <v-btn color="primary" @click="openConfirmRegisterDialog">登録</v-btn>
              <ConfirmDialog
                ref="discard"
                title="編集破棄確認"
                message="実験の作成を中止して、編集内容を破棄します。よろしいですか？"
                buttonMessage="破棄"
                @confirm="confirmDiscard"
                color="error"
              >
              </ConfirmDialog>
              <ConfirmDialog
                ref="register"
                title="実験登録確認"
                message="入力した内容で実験を登録します。よろしいですか？"
                buttonMessage="登録"
                @confirm="confirmRegister"
                color="primary"
              >
              </ConfirmDialog>
            </v-card-actions>
          </v-col>

          <v-col class="py-0 ma-0" cols="12" sm="3" md="3">
            <div height="100%" style="background:#196aab" class="fill-height">       
              <v-img
              :src="require('@/assets/clip-work-process.png')"
              :aspect-ratio="16/9"
              style="position:fixed;top:0px;right:-20px;width:30%"
              ></v-img>
            </div>
          </v-col>
        </v-row>
      </v-container>
    </v-card>
  </v-dialog>
</template>

<script>
import UserApi from '@/plugins/axios/modules/user'
import ExperimentApi from '@/plugins/axios/modules/experiment'
import RegisterAgreementCard from '@/components/RegisterAgreementCard'
import RegisterFacesheetCard from '@/components/RegisterFacesheetCard'
import RegisterAssessmentCard from '@/components/RegisterAssessmentCard'
import RegisterQuestionnaireCard from '@/components/RegisterQuestionnaireCard'

export default {
  data() {
    return {
      dialog: false,
      workflow: [
        "agreement",
        "facesheet",
        "assessment",
        "questionnaire",
        "transfer",
        "thanks"
      ],
      name: ""
    }
  },
  methods: {
    open() {
      this.dialog = true
    },
    cancel() {
      this.dialog = false
    },
    openConfirmDiscardDialog () {
      this.$refs.discard.open()
    },
    confirmDiscard() {
      this.dialog = false
    },
    openConfirmRegisterDialog () {
      this.$refs.register.open()
    },
    confirmRegister() {
      ExperimentApi.createExperiment(this.createPostData()).then(()=>{
        this.dialog = false
        this.$toast.success('実験を作成しました！')
        this.$emit('register')
      })
    },
    createPostData() {
      let data = []
      this.workflow.forEach((work) => {
        switch (work) {
          case "agreement":
            data.push({
              "work": "agreement",
              "text": this.$refs.agreement[0].claim_text
            })
            break;
          case "facesheet":
            data.push({
              "work": "facesheet",
              "facesheet": this.$refs.facesheet[0].facesheet
            })
            break;
          case "assessment":
            for (var step of [...Array(this.$refs.assessment[0].num_steps).keys()]) {
              data.push({
                "work": "assessment",
                "num_files": this.$refs.assessment[0].sample_list[step],
                "point": this.$refs.assessment[0].point_list[step],
                "is_practice": this.$refs.assessment[0].is_practice_list[step],
                "criteria": this.$refs.assessment[0].criteria_list[step].join(",")
              })
            }
            break;
          case "questionnaire":
            data.push({
              "work": "questionnaire",
              "url": this.$refs.questionnaire[0].form_url
            })
            break;
          case "transfer":
            data.push({
              "work": "transfer"
            })
            break;
          case "thanks":
            data.push({
              "work": "thanks"
            })
          }
        })
        return {"name": this.name, "data": data}
    }
  }
}
</script>

<style scoped>
.card-title {
  color:rgba(0, 0, 0, 0.87);
  font-size:20px;
}
</style>