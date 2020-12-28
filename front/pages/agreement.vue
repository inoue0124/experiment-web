<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      
      <h1 align="center">協力同意書</h1>

      <h2>評価実験の説明</h2>

      <p class="text-justify">
        ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。
        ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。
        ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。
      </p>

      <p class="text-justify">
        ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。
        ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。
        ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。ここに評価実験の説明が入ります。
      </p>

      <h2>協力同意書</h2>

      <p class="text-justify">
        ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。
        ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。
        ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。
      </p>

      <p class="text-justify">
        ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。
        ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。
        ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。ここに協力同意書の内容が入ります。
      </p>

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
    isAgree: false
  }),

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
        WorkflowApi.complete().then((res) => {
          this.$router.push(res.name.toLowerCase())
        })
      }
    }
  }
}
</script>