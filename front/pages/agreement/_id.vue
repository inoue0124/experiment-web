<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="12" sm="8" md="6">

      <StepProgress class="mb-10"></StepProgress>

      <p v-html="claim_text"></p>
      
      <div align="center">
        <v-form ref="agreement_form">

          <v-checkbox 
          v-model="isAgree" 
          label="よって、わたしは、本実験に参加することに同意します。" 
          :rules="[required]"
          ></v-checkbox>

          <v-text-field
            v-model="name"
            label="氏名"
            :rules="[required]"
            class="mb-10"
          ></v-text-field>

        </v-form>

        <v-btn color="primary" type="submit" @click="next">次へ進む</v-btn>

        <v-card class="mt-16">
          <v-card-text>
            <p>
              ボイクマン総子(Ph.D.)<br>
              東京大学 大学院総合文化研究科<br>
              グローバルコミュニケーション研究センター、教授<br>
              153-8902　東京都目黒区駒場3-8-1 東京大学<br>
              beuckmann@g.ecc.u-tokyo.ac.jp
            </p>
          </v-card-text>
        </v-card>
      </div>

    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import AgreementApi from '@/plugins/axios/modules/agreement'
import StepProgress from '@/components/StepProgress'

export default {
  middleware: 'redirector',

  data: () => ({
    isAgree: false,
    claim_text: '',
    name: ''
  }),

  mounted() {
    AgreementApi.getAgreement(this.$route.params.id).then((res) => {
      //this.claim_text = res.text.replace(/<p><br><\/p>/g, '')
      this.claim_text = res.text
    })
  },

  methods: {
    required: value => !!value || "必須項目です。",
    next() {
      if (this.$refs.agreement_form.validate()) {
        WorkflowApi.complete(this.$route.params.id).then((res) => {
          this.$router.push(res.work.name.toLowerCase())
        })
      }
    }
  }
}
</script>