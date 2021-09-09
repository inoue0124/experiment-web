<template>
  <v-card>
    <v-card-text>
      <p>
        ファイルアップロード（pdfと画像ファイルが使用できます。拡張子の前のファイル名は「instruction」にして下さい。）
      </p>
      <FileUploader
        :directory="'instruction/' + instruction.t_workflow_id + '/'"
        file_type="application/pdf,image/*"
      ></FileUploader>

      <v-row>
        <v-col>
          <v-expansion-panels accordion>
            <v-expansion-panel>
              <v-expansion-panel-header color="primary" style="color: white"
                >アップロードしたファイル一覧</v-expansion-panel-header
              >
              <v-expansion-panel-content>
                <v-data-table
                  :headers="[
                    { text: 'ファイル名', value: 'key' },
                    { text: '作成日時', value: 'last_modified' },
                    { text: '操作', value: 'actions', sortable: false },
                  ]"
                  :items="files"
                >
                  <template v-slot:[`item.last_modified`]="{ item }">
                    <span>{{
                      new Date(item.last_modified).toLocaleString()
                    }}</span>
                  </template>

                  <template v-slot:[`item.actions`]="{ item }">
                    <v-icon small class="mr-2" @click="downloadFile(item)"
                      >mdi-download</v-icon
                    >
                    <v-icon small @click="deleteFile(item)">mdi-delete</v-icon>
                  </template>

                  <template v-slot:no-data> データがありません </template>
                </v-data-table>
              </v-expansion-panel-content>
            </v-expansion-panel>
          </v-expansion-panels>
        </v-col>
        <v-col cols="1">
          <v-btn outlined @click="refresh"><v-icon>mdi-refresh</v-icon></v-btn>
        </v-col>
      </v-row>
    </v-card-text>
  </v-card>
</template>

<script>
import FileUploader from '@/components/FileUploader'
import AwsApi from '@/plugins/axios/modules/aws'

export default {
  components: {
    FileUploader,
  },
  props: {
    instruction_prop: Object,
  },
  data() {
    return {
      instruction: {},
      files: null,
    }
  },
  mounted() {
    if (this.instruction_prop !== undefined) {
      this.instruction = this.instruction_prop
      this.refresh()
    }
  },
  methods: {
    refresh() {
      AwsApi.listDisclosedFiles(
        'instruction/' + this.instruction.t_workflow_id
      ).then((res) => {
        this.files = res
      })
    },
    downloadFile(item) {
      AwsApi.downloadFile(
        true,
        item.key,
        item.key.split('/').slice(-1)[0],
        item.key.split('.').slice(-1)[0]
      ).then((res) => {
        let link = document.createElement('a')
        link.href = window.URL.createObjectURL(res)
        link.download = item.key.split('/').slice(-1)[0]
        link.click()
      })
    },
    deleteFile(item) {
      AwsApi.deleteFile(
        item.key,
        item.key.split('/').slice(-1)[0],
        item.key.split('.').slice(-1)[0]
      ).then((res) => {
        this.refresh()
      })
    },
  },
}
</script>
