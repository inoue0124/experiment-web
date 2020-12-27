<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      <v-card class="pa-md-10 mx-lg-auto">
        <v-card-title class="headline">
          ログイン
        </v-card-title>
        <v-cart-text>
          <v-form @submit.prevent="post">
            <v-text-field
              v-model="email"
              :counter="10"
              label="メールアドレス"
              required
            ></v-text-field>

            <v-text-field
              v-model="password"
              label="パスワード"
              type="password"
              required
            ></v-text-field>

            <v-btn color="primary" type="submit">ログイン</v-btn>

          </v-form>
        </v-cart-text>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'

export default {
  data() {
    return {
      email: '',
      password: ''
    }
  },
  methods: {
    post() {
      this.$axios.post(
        'http://localhost:3000/login',
        {
          email: this.email,
          password: this.password
        }
      ).then((res) => {
        WorkflowApi.getNextWork().then((res) => {
          this.$router.push(res.name.toLowerCase())
        })
      })
    }
  }
}
</script>