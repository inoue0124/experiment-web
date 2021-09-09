<template>
  <v-card>
    <v-card-text>
      <v-row>
        <v-col cols="12" sm="4" md="4">
          <v-checkbox
            v-model="assessment.is_practice"
            :label="
              assessment.is_second_time
                ? '練習モードにする（ラジオボタンが表示されなくなります。）'
                : '練習モードにする（ラジオボタンとコメント欄が表示されなくなります。）'
            "
          ></v-checkbox>
        </v-col>

        <v-col cols="12" sm="4" md="4" v-if="!assessment.is_practice">
          <v-select
            v-model="assessment.point"
            :items="point_selection"
            label="評価の段階数"
            class="ma-2"
          ></v-select>
        </v-col>

        <v-col cols="12" sm="4" md="4">
          <v-select
            v-model="assessment.num_files"
            :items="sample_selection"
            :label="`音声サンプル数`"
            class="ma-2"
          ></v-select>
        </v-col>
      </v-row>

      <v-row v-if="!assessment.is_practice">
        <v-col v-for="key in assessment.point" :key="key">
          <v-text-field
            :label="`評価値${key}のラベル`"
            v-model="criteria[key - 1]"
            outlined
          ></v-text-field>
        </v-col>
      </v-row>

      <v-row
        v-if="!assessment.is_practice && !assessment.is_second_time"
        class="mb-10"
      >
        <v-combobox
          multiple
          v-model="reasons"
          label="判断理由"
          append-icon
          chips
          deletable-chips
        ></v-combobox>
      </v-row>

      <p>
        音声ファイルアップロード（テストの音声は「test.mp3」、本番音声は「1.wav,
        2.wav・・・」のようにして下さい。テストの音声をアップロードしなかった場合、評価者の画面には表示されません。）
      </p>
      <FileUploader
        :directory="'assessment/' + assessment.t_workflow_id + '/'"
        file_type="audio/*"
      ></FileUploader>

      <p>
        インストラクション、ルーブリックファイルアップロード（pdfと画像ファイルが使用できます。拡張子の前のファイル名はそれぞれ「instruction」、「rubric」にして下さい。）
      </p>
      <FileUploader
        :directory="'assessment/' + assessment.t_workflow_id + '/'"
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
    assessment_prop: Object,
  },
  data() {
    return {
      assessment: {
        is_practice: false,
        point: 0,
        pdf_url: '',
        num_files: 0,
        criteria: '',
        is_second_time: false,
      },
      point_selection: [...Array(10).keys()].map((i) => ++i),
      sample_selection: [...Array(101).keys()].map((i) => ++i),
      criteria: null,
      reasons: null,
      files: null,
    }
  },
  watch: {
    criteria: function (newCriteria) {
      this.assessment.criteria = newCriteria.join(',')
    },
    reasons: function (newReasons) {
      this.assessment.reasons = newReasons.join(',')
    },
  },
  mounted() {
    if (this.assessment_prop !== undefined) {
      this.assessment = this.assessment_prop
      this.criteria = this.assessment.criteria.split(',')
      this.reasons = this.assessment.reasons.split(',')
      this.refresh()
    }
  },
  methods: {
    refresh() {
      AwsApi.listDisclosedFiles(
        'assessment/' + this.assessment.t_workflow_id
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
