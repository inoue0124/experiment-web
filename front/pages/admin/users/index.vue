<template>
  <v-data-table
    :headers="headers"
    :items="users"
    sort-by="id"
    class="elevation-1"
  >
    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>ユーザ管理</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn
          color="primary"
          dark
          class="mb-2"
          @click="openRegisterDialog()"
        >
          新規登録
        </v-btn>

        <RegisterUserDialog ref="register" @generate="reloadData"></RegisterUserDialog>

        <v-dialog v-model="dialogEdit" max-width="500px">
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
                    <v-text-field
                      v-model="editedItem.t_experiment_id"
                      label="実験ID"
                    ></v-text-field>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="closeEdit">キャンセル</v-btn>
              <v-btn color="primary" dark @click="confirmEdit">保存</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>

        <ConfirmDialog
          ref="confirm"
          title="削除確認"
          :message="deleteMessage"
          buttonMessage="削除"
          @confirm="confirmDelete"
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
      { text: 'id', value: 'id'},
      { text: 'uuid', value: 'uuid' },
      { text: 'メールアドレス', value: 'email' },
      { text: '実験ID', value: 't_experiment_id' },
      { text: '操作', value: 'actions', sortable: false },
    ],
    users: [],
    editedIndex: -1,
    editedItem: {
      uuid: '',
      email: '',
      t_experiment_id: 0
    }
  }),

  computed: {
    deleteMessage() {
      return `${this.editedItem.uuid} のユーザ情報を削除します。よろしいですか。`
    }
  },

  mounted () {
    this.reloadData()
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
      this.editedItem = Object.assign({}, item)
      this.$refs.confirm.open()
    },

    confirmEdit () {
      UserApi.updateUser(this.users[this.editedIndex].id, this.editedItem).then(()=>{
        Object.assign(this.users[this.editedIndex], this.editedItem)
      })
      this.closeEdit()
    },

    confirmDelete () {
      this.users.splice(this.editedIndex, 1)
    },

    closeEdit () {
      this.dialogEdit = false
    },

    closeDelete () {
      this.dialogDelete = false
    }
  },
}
</script>

