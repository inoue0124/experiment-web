<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="12" sm="8" md="6">

      <StepProgress class="mb-10"></StepProgress>

      <p v-html="claim_text"></p>
      
      <div align="center">
        <v-checkbox 
        v-model="isAgree" 
        :error-messages="checkboxErrors" 
        :label="`以上の内容に同意します。`" 
        required
        @change="$v.isAgree.$touch()"
        @blur="$v.isAgree.$touch()"
        ></v-checkbox>

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
import { validationMixin } from 'vuelidate'
import { required } from 'vuelidate/lib/validators'
import WorkflowApi from '@/plugins/axios/modules/workflow'
import AgreementApi from '@/plugins/axios/modules/agreement'
import StepProgress from '@/components/StepProgress'

export default {
  middleware: 'redirector',
  mixins: [validationMixin],

  validations: {
    isAgree: {
      checked (val) {
        return val
      },
    },
  },

  data: () => ({
    isAgree: false,
    claim_text: ''
  }),

  mounted() {
    AgreementApi.getAgreement(this.$route.params.id).then((res) => {
      this.claim_text = res.text.replace(/<p><br><\/p>/g, '')
    })
  },

  computed: {
    checkboxErrors () {
      const errors = []
      if (!this.$v.isAgree.$dirty) return errors
      !this.$v.isAgree.checked && errors.push('同意する場合はチェックをお願いします。')
      return errors
    },
  },

  methods: {
    next() {
      this.$v.$touch()
      if (!this.$v.$invalid) {
        WorkflowApi.complete(this.$route.params.id).then((res) => {
          this.$router.push(res.work.name.toLowerCase())
        })
      }
    }
  }
}
</script>