<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="12" sm="8" md="6">
      
      <h1 align="center" class="mb-16">協力同意書</h1>

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
      </div>

    </v-col>
  </v-row>
</template>

<script>
import { validationMixin } from 'vuelidate'
import { required } from 'vuelidate/lib/validators'
import WorkflowApi from '@/plugins/axios/modules/workflow'
import AgreementApi from '@/plugins/axios/modules/agreement'

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
      this.claim_text = res.text
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