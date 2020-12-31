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
              <v-btn icon @click="openConfirmDialog">
                <v-icon>mdi-close</v-icon>
              </v-btn>
              <ConfirmDialog
                ref="discard"
                title="編集破棄確認"
                message="実験の作成を中止して、編集内容を破棄します。よろしいですか？"
                buttonMessage="破棄"
                @confirm="confirmDiscard"
              >
              </ConfirmDialog>
              <span class="headline">新規実験作成</span>
            </v-toolbar>

            <v-card-text class="pa-10">
              <p class="mb-3 mx-10 card-title">同意書設定</p>
              <RegisterAgreementCard class="mx-10 pa-5 mb-16"></RegisterAgreementCard>

              <p class="mb-3 mx-10 card-title">フェイスシート設定</p>
              <RegisterFacesheetCard class="mx-10 pa-5 mb-16"></RegisterFacesheetCard>

              <p class="mb-3 mx-10 card-title">評価実験設定</p>
              <RegisterAssessmentCard class="mx-10 pa-5 mb-16"></RegisterAssessmentCard>

              <p class="mb-3 mx-10 card-title">アンケート設定</p>
              <RegisterQuestionnaireCard class="mx-10 pa-5 mb-16"></RegisterQuestionnaireCard>
              
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="cancel">キャンセル</v-btn>
              <v-btn color="primary" dark @click="register">登録</v-btn>
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
import RegisterAgreementCard from '@/components/RegisterAgreementCard'
import RegisterFacesheetCard from '@/components/RegisterFacesheetCard'
import RegisterAssessmentCard from '@/components/RegisterAssessmentCard'
import RegisterQuestionnaireCard from '@/components/RegisterQuestionnaireCard'

export default {
  data() {
    return {
      dialog: false
    }
  },
  methods: {
    open() {
      this.dialog = true
    },
    cancel() {
      this.dialog = false
    },
    openConfirmDialog () {
      this.$refs.discard.open()
    },
    confirmDiscard() {
      this.dialog = false
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