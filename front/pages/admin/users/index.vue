<template>
  <v-data-table
    :headers="headers"
    :items="users"
    class="elevation-1 my-16"
  >
    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>ユーザ一覧</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn
          color="primary"
          class="mb-2 mr-2"
          @click="downloadCSV()"
        >
          CSVダウンロード
        </v-btn>
        <v-btn
          color="primary"
          dark
          class="mb-2"
          @click="openRegisterDialog()"
        >
          新規登録
        </v-btn>

        <RegisterUserDialog ref="register" @generate="reloadData"></RegisterUserDialog>

        <v-dialog v-model="dialogEdit" max-width="800px">
          <v-card>
            <v-card-title>
              <span class="headline">編集</span>
            </v-card-title>

            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="6" md="4">
                    <v-text-field
                      v-model="editedItem.uuid"
                      label="ユニークID"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <v-text-field
                      v-model="editedItem.email"
                      label="Email"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <v-select
                      v-model="editedItem.t_experiment_id"
                      :items="experiments"
                      item-text="name"
                      item-value="id"
                      label="対象の実験"
                      class="ma-2"
                    ></v-select>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn @click="closeEdit">キャンセル</v-btn>
              <v-btn color="primary" @click="confirmEdit">保存</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>

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
    </template>

    <template v-slot:[`item.actions`]="{ item }">
      <v-icon small class="mr-2" @click="openEditDialog(item)">mdi-pencil</v-icon>
      <v-icon small @click="openDeleteDialog(item)">mdi-delete</v-icon>
    </template>

    <template v-slot:no-data>
      データがありません
    </template>
  </v-data-table>
</template>

<script>
import UserApi from '@/plugins/axios/modules/user'
import ExperimentApi from '@/plugins/axios/modules/experiment'
import RegisterUserDialog from '@/components/dialogs/RegisterUserDialog'
import ConfirmDialog from '@/components/dialogs/ConfirmDialog'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',

  components: {
    ConfirmDialog,
    RegisterUserDialog
  },
  
  data: () => ({
    dialogEdit: false,
    headers: [
      { text: 'ユーザID', value: 'id'},
      { text: 'ログインID', value: 'uuid' },
      { text: 'メールアドレス', value: 'email' },
      { text: '実験ID', value: 't_experiment_id' },
      { text: '実験名', value: 'experiment_name' },
      { text: '更新日時', value: 'updated_at'},
      { text: '作成日時', value: 'created_at'},
      { text: '操作', value: 'actions', sortable: false }
    ],
    users: [],
    editedIndex: -1,
    editedItem: {
      uuid: '',
      email: '',
      t_experiment_id: 0
    },
    experiments: []
  }),

  computed: {
    deleteMessage() {
      return `${this.editedItem.uuid} のユーザ情報を削除します。よろしいですか。`
    }
  },

  mounted () {
    this.reloadData()
    ExperimentApi.listExperiments().then((res)=>{
      this.experiments = res
    })
  },

  methods: {
    reloadData() {
      UserApi.getUsers().then((res) => {
        this.users = res
      })
    },

    openRegisterDialog(){
      this.$refs.register.open()
    },

    openEditDialog (item) {
      this.editedIndex = this.users.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialogEdit = true
    },

    openDeleteDialog (item) {
      this.editedIndex = this.users.indexOf(item)
      this.$refs.confirm.open()
    },

    confirmEdit () {
      UserApi.updateUser(this.users[this.editedIndex].id, this.editedItem).then(()=>{
        this.$toast.success('保存しました！')
        this.reloadData()
      })
      this.closeEdit()
    },

    confirmDelete () {
      UserApi.deleteUser(this.users[this.editedIndex].id).then(()=>{
        this.$toast.success('削除しました！')
        this.reloadData()
      })
    },

    closeEdit () {
      this.dialogEdit = false
    },

    closeDelete () {
      this.dialogDelete = false
    },

    downloadCSV () {
      var csv = '\ufeff' + 'ID,ログインID,メールアドレス,実験ID,実験名,更新日時,作成日時\n'
      this.users.forEach(el => {
        var line = el['id'] + ',' + el['uuid'] + ',' + el['email'] + ',' + el['t_experiment_id'] + ',' 
        + el['experiment_name'] + ',' + el['updated_at'] + ',' + el['created_at'] + '\n'
        csv += line
      })
      let blob = new Blob([csv], { type: 'text/csv' })
      let link = document.createElement('a')
      link.href = window.URL.createObjectURL(blob)
      link.download = 'user_list.csv'
      link.click()
    }
  },
}
</script>

