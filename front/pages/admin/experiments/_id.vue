<template>
    <v-row>
      <v-col cols="12" sm="12" md="12">
        <v-toolbar flat class="mb-3">
          <a link @click="goBack">実験一覧</a>/編集
          <v-spacer></v-spacer>
          <v-btn color="error" @click="openDeleteDialog" class="mr-5">この実験を削除</v-btn>
          <v-btn color="primary" @click="confirmRegister">編集内容を保存</v-btn>
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
              <RegisterAgreementCard class=" pa-5 mb-16" ref="agreement" :claim_text_prop="work_data[key].text"></RegisterAgreementCard>
            </div>
            
            <div v-if="work=='facesheet'">
              <p class="mb-3 card-title">フェイスシート設定</p>
              <RegisterFacesheetCard class=" pa-5 mb-16" ref="facesheet"></RegisterFacesheetCard>
            </div>

            <div v-if="work=='assessment'">
              <p class="mb-3 card-title">評価実験設定</p>
              <UpdateAssessmentCard class=" pa-5 mb-16" ref="assessment" :assessment_prop="work_data[key]"></UpdateAssessmentCard>
            </div>
            
            <div v-if="work=='questionnaire'">
              <p class="mb-3 card-title">アンケート設定</p>
              <RegisterQuestionnaireCard class=" pa-5 mb-16" ref="questionnaire" :form_url_prop="work_data[key].url"></RegisterQuestionnaireCard>
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
import UpdateAssessmentCard from '@/components/UpdateAssessmentCard'
import RegisterQuestionnaireCard from '@/components/RegisterQuestionnaireCard'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',
  data() {
    return {
      dialog: false,
      workflow: [],
      name: "",
      work_data: []
    }
  },

  mounted() {
    ExperimentApi.getExperiment(this.$route.params.id).then((res)=>{
      this.workflow = res.works
      this.name = res.experiment.name
      this.work_data = res.work_data
    })
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
         this.$toast.success('削除しました！')
      })
    },

    goBack() {
      this.$router.back()
    },

    closeDelete () {
      this.dialogDelete = false
    },
    
    confirmRegister() {
      ExperimentApi.updateExperiment(this.$route.params.id, this.createPostData()).then(()=>{
        this.dialog = false
        this.$toast.success('保存しました！')
      })
    },
    createPostData() {
      let data = []
      let assess_index = 0
      this.work_data.forEach((work, index) => {
        switch (this.workflow[index]) {
          case "agreement":
            data.push({
              "work": "agreement",
              "id": work.id,
              "text": this.$refs.agreement[0].claim_text
            })
            break;
          case "facesheet":
            data.push({
              "work": "facesheet",
              "id": work.id,
              "facesheet": this.$refs.facesheet[0].facesheet
            })
            break;
          case "assessment":
            data.push({
              "work": "assessment",
              "id": work.id,
              "num_files": this.$refs.assessment[assess_index].assessment.num_files,
              "point": this.$refs.assessment[assess_index].assessment.point,
              "is_practice": this.$refs.assessment[assess_index].assessment.is_practice
            })
            assess_index+=1
            break;
          case "questionnaire":
            data.push({
              "work": "questionnaire",
              "id": work.id,
              "url": this.$refs.questionnaire[0].form_url
            })
            break;
          case "transfer":
            data.push({
              "work": "transfer",
              "id": work.id
            })
            break;
          case "thanks":
            data.push({
              "work": "thanks",
              "id": work.id
            })
          }
        })
        return {"id": this.$route.params.id, "name": this.name, "data": data}
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