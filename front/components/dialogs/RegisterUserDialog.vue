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
            <v-toolbar flat class="my-5">
              <v-spacer></v-spacer>
              <v-select
                v-model="experiment_id"
                :items="experiments"
                item-text="name"
                item-value="id"
                label="対象の実験"
                class="mr-5"
                outlined
              ></v-select>
              <v-select
                v-model="num_generate"
                :items="nums"
                label="生成するアカウントの数"
                class="mr-5"
                outlined
              ></v-select>
              <v-btn
                color="secondary"
                class="mb-10"
                @click="generate()"
                :disabled="experiment_id===null || num_generate===0"
              >
                生成
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
        <v-btn color="primary" @click="register" :disabled="users.length===0">登録</v-btn>
      </v-card-actions>

    </v-card>
  </v-dialog>
</template>

<script>
import UserApi from '@/plugins/axios/modules/user'
import ExperimentApi from '@/plugins/axios/modules/experiment'

export default {
  data() {
    return {
      dialog: false,
      headers: [
        { text: 'ID', value: 'uuid' },
        { text: 'メールアドレス', value: 'email' },
        { text: 'パスワード', value: 'password' },
        { text: '対象の実験', value: 'experiment_name' }
      ],
      users: [],
      num_generate: 1,
      nums: [...Array(30).keys()].map(i => ++i),
      experiment_id: null,
      experiments: [],
    }
  },
  mounted() {
    ExperimentApi.listExperiments().then((res)=>{
      this.experiments = res
    })
  },
  methods: {
    open() {
      this.dialog = true
    },
    cancel() {
      this.users = []
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
          experiment_name: this.experiments.find((elm) => elm.id === this.experiment_id).name,
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
      var csv = '\ufeff' + 'ID,メールアドレス,パスワード,実験ID,実験名\n'
      this.users.forEach(el => {
        var line = el['uuid'] + ',' + el['email'] + ',' + el['password'] + ',' 
        + el['t_experiment_id'] + ',' + this.experiments.find((elm) => elm.id === this.experiment_id).name +'\n'
        csv += line
      })
      let blob = new Blob([csv], { type: 'text/csv' })
      let link = document.createElement('a')
      link.href = window.URL.createObjectURL(blob)
      link.download = 'password_list.csv'
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