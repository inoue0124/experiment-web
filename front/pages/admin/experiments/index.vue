<template>
  <v-data-table
    :headers="headers"
    :items="experiments"
    class="elevation-1 my-16"
  >
    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>実験一覧</v-toolbar-title>
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
      </v-toolbar>
    </template>

    <template v-slot:[`item.updated_at`]="{ item }">
      <span>{{ new Date(item.updated_at).toLocaleString() }}</span>
    </template>

    <template v-slot:[`item.created_at`]="{ item }">
      <span>{{ new Date(item.created_at).toLocaleString() }}</span>
    </template>

    <template v-slot:[`item.actions`]="{ item }">
      <v-icon small class="mr-2" @click="toEdit(item)">mdi-pencil</v-icon>
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
      { text: '実験ID', value: 'id'},
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

    toEdit (item) {
      this.editedIndex = this.experiments.indexOf(item)
      this.$router.push(`experiments/${this.experiments[this.editedIndex].id}`)
    },

    downloadCSV () {
      var csv = '\ufeff' + '実験ID,実験名,更新日時,作成日時\n'
      this.experiments.forEach(el => {
        var line = el['id'] + ',' + el['name'] + ',' + el['updated_at'] + ',' + el['created_at'] + '\n'
        csv += line
      })
      let blob = new Blob([csv], { type: 'text/csv' })
      let link = document.createElement('a')
      link.href = window.URL.createObjectURL(blob)
      link.download = 'experiment_list.csv'
      link.click()
    }
  },
}
</script>