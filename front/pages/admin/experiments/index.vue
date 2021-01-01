<template>
  <v-data-table
    :headers="headers"
    :items="experiments"
    sort-by="id"
    class="elevation-1 my-16"
  >
    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>実験管理</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn
          color="primary"
          dark
          class="mb-2"
          @click="openRegisterDialog()"
        >
          新規登録
        </v-btn>

        <CreateExperimentModal 
          ref="register" 
          @register="reloadData"
        >
        </CreateExperimentModal>

        <v-dialog v-model="dialogEdit" max-width="500px">
          <v-card>
            <v-card-title>
              <span class="headline">編集</span>
            </v-card-title>

            <v-card-text>
              <v-container>
                <v-text-field
                  v-model="editedItem.name"
                  label="実験名"
                ></v-text-field>
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
import ExperimentApi from '@/plugins/axios/modules/experiment'
import ConfirmDialog from '@/components/dialogs/ConfirmDialog'
import CreateExperimentModal from '@/components/modals/CreateExperimentModal'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',

  components: {
    ConfirmDialog,
    CreateExperimentModal
  },
  
  data: () => ({
    dialogEdit: false,
    headers: [
      { text: 'id', value: 'id'},
      { text: '実験名', value: 'name' },
      { text: '更新日時', value: 'updated_at'},
      { text: '作成日時', value: 'created_at'},
      { text: '操作', value: 'actions', sortable: false }
    ],
    experiments: [],
    editedIndex: -1,
    editedItem: {
      name: ''
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
      ExperimentApi.listExperiments().then((res) => {
        this.experiments = res
      })
    },

    openRegisterDialog(){
      this.$refs.register.open()
    },

    openEditDialog (item) {
      this.editedIndex = this.experiments.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialogEdit = true
    },

    openDeleteDialog (item) {
      this.editedIndex = this.experiments.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.$refs.confirm.open()
    },

    confirmEdit () {
      ExperimentApi.updateExperiment(this.experiments[this.editedIndex].id, this.editedItem).then(()=>{
        Object.assign(this.experiments[this.editedIndex], this.editedItem)
      })
      this.closeEdit()
    },

    confirmDelete () {
      ExperimentApi.deleteExperiment(this.experiments[this.editedIndex].id).then(()=>{
         this.experiments.splice(this.editedIndex, 1)
      })
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