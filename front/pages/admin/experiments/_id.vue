<template>
    <v-row>
      <v-col cols="12" sm="12" md="12">
        <v-toolbar flat class="mb-3">
          <a link @click="goBack">実験一覧</a>/編集
          <v-spacer></v-spacer>
          <v-btn color="error" @click="openDeleteDialog" class="mr-5">この実験を削除</v-btn>
          <v-btn color="primary" @click="confirmRegister">保存</v-btn>
          <ConfirmDialog
            ref="confirm"
            title="削除確認"
            :message="deleteMessage"
            buttonMessage="削除"
            @confirm="confirmDelete"
            color="error"
          >
          </ConfirmDialog>
        </v-toolbar>

        <v-card-text>
          <p class="mb-3 card-title">実験名設定</p>
          <v-card class=" pa-5 mb-16">
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
              <p class="mb-3 card-title">同意書設定</p>
              <RegisterAgreementCard class=" pa-5 mb-16" ref="agreement"></RegisterAgreementCard>
            </div>
            
            <div v-if="work=='facesheet'">
              <p class="mb-3 card-title">フェイスシート設定</p>
              <RegisterFacesheetCard class=" pa-5 mb-16" ref="facesheet"></RegisterFacesheetCard>
            </div>

            <div v-if="work=='assessment'">
              <p class="mb-3 card-title">評価実験設定</p>
              <RegisterAssessmentCard class=" pa-5 mb-16" ref="assessment"></RegisterAssessmentCard>
            </div>
            
            <div v-if="work=='questionnaire'">
              <p class="mb-3 card-title">アンケート設定</p>
              <RegisterQuestionnaireCard class=" pa-5 mb-16" ref="questionnaire"></RegisterQuestionnaireCard>
            </div>
          </div>
        </v-card-text>
      </v-col>
    </v-row>
</template>

<script>
import UserApi from '@/plugins/axios/modules/user'
import ExperimentApi from '@/plugins/axios/modules/experiment'
import RegisterAgreementCard from '@/components/RegisterAgreementCard'
import RegisterFacesheetCard from '@/components/RegisterFacesheetCard'
import RegisterAssessmentCard from '@/components/RegisterAssessmentCard'
import RegisterQuestionnaireCard from '@/components/RegisterQuestionnaireCard'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',
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

  computed: {
    deleteMessage() {
      return `${this.name} を削除します。よろしいですか。`
    }
  },

  methods: {
    openDeleteDialog (item) {
      this.$refs.confirm.open()
    },

    confirmDelete () {
      ExperimentApi.deleteExperiment(this.$route.params.id).then(()=>{
         this.goBack()
      })
    },

    goBack() {
      this.$router.back()
    },

    closeDelete () {
      this.dialogDelete = false
    },
    
    confirmRegister() {
      ExperimentApi.createExperiment(this.createPostData()).then(()=>{
        this.dialog = false
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
                "num_files": this.$refs.assessment[0].num_samples[step]
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