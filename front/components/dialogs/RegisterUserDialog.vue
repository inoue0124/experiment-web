<template>
  <v-dialog v-model="dialog" persistent max-width="800px">
    <v-card>
      <v-card-title>
        <span class="headline">新規登録</span>
      </v-card-title>
      <v-card-text>
        <v-data-table
          :headers="headers"
          :items="users"
          sort-by="id"
        >
          <template v-slot:top>
            <v-toolbar flat>
              <v-spacer></v-spacer>
              <v-select
                v-model="experiment_id"
                :items="experiments"
                label="割り当てる実験"
                class="ma-2"
              ></v-select>
              <v-select
                v-model="num_generate"
                :items="nums"
                label="生成するアカウントの数"
                class="ma-2"
              ></v-select>
              <v-btn
                color="secondary"
                dark
                class="mb-3 mr-2"
                @click="generate()"
              >
                ランダム生成
              </v-btn>
              <v-btn
                color="secondary"
                dark
                class="mb-3 mr-2"
                @click="generate()"
              >
                csv読み込み
              </v-btn>
            </v-toolbar>
          </template>

          <template v-slot:no-data>
            データがありません
          </template>

        </v-data-table>
      </v-card-text>

      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="blue darken-1" text @click="cancel">キャンセル</v-btn>
        <v-btn color="primary" dark @click="register">登録</v-btn>
      </v-card-actions>

    </v-card>
  </v-dialog>
</template>

<script>
import UserApi from '@/plugins/axios/modules/user'

export default {
  data() {
    return {
      dialog: false,
      headers: [
        { text: 'ID', value: 'uuid' },
        { text: 'メールアドレス', value: 'email' },
        { text: 'パスワード', value: 'password' },
        { text: '実験ID', value: 't_experiment_id' }
      ],
      users: [],
      num_generate: 1,
      nums: [...Array(31).keys()],
      experiment_id: 1,
      experiments: [...Array(31).keys()],
    }
  },
  methods: {
    open() {
      this.dialog = true
    },
    cancel() {
      this.dialog = false
    },
    generate() {
      for (let i=0; i<this.num_generate; i++) {
        const password = this.getRandomStr(8)
        const user = {
          uuid: this.getRandomStr(8),
          email: '',
          password: password,
          password_confirmation: password,
          t_experiment_id: this.experiment_id
        }
        this.users.push(user)
      }
    },
    register() {
      UserApi.bulkCreateUsers(this.users).then((res)=>{
        this.downloadCSV()
        this.$emit('generate')
        this.users = []
        this.dialog = false
      })
    },

    getRandomStr(len){
      const LENGTH = len
      const SOURCE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-@*~^"
      let result = ''
      for(let i=0; i<LENGTH; i++){
        result += SOURCE[Math.floor(Math.random() * SOURCE.length)];
      }      
      return result
    },

    downloadCSV () {
      var csv = '\ufeff' + 'ID,メールアドレス,パスワード,実験ID\n'
      this.users.forEach(el => {
        var line = el['uuid'] + ',' + el['email'] + ',' + el['password'] + ',' + el['t_experiment_id'] + '\n'
        csv += line
      })
      let blob = new Blob([csv], { type: 'text/csv' })
      let link = document.createElement('a')
      link.href = window.URL.createObjectURL(blob)
      link.download = 'user_list.csv'
      link.click()
    }
  }
}
</script>

<style scoped>
.dialog-Button {
  font-weight: bold;
}
</style>