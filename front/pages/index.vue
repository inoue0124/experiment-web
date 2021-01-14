<template>
  <v-row justify="center" align="center" align-center>
    <v-col cols="12" sm="6" md="6">
      <v-card class="pa-md-10 mt-16">
        <v-card-title class="headline">
          ログイン
        </v-card-title>
        <v-card-text>
          <v-form @submit.prevent="post">
            <v-text-field
              v-model="email"
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
        </v-card-text>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import SessionApi from '@/plugins/axios/modules/session'

export default {
  data() {
    return {
      email: '',
      password: ''
    }
  },
  methods: {
    post() {
      SessionApi.login(this.email, this.password).then((session) => {
        // admin(user_type:1)だったら管理画面へリダイレクト
        if (session.data.user_type===0) {
          this.$router.push(`/admin/users`)
        } else {
          WorkflowApi.getWork().then((res) => {
            this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
          })
        }
      })
    }
  }
}
</script>