<template>
  <v-card>
    <v-card-text>
      <v-row>
        <v-col cols="12" sm="4" md="4">
          <v-checkbox
            v-model="assessment.is_practice"
            label="練習モードにする"
          ></v-checkbox>
        </v-col>

        <v-col cols="12" sm="4" md="4">
          <v-select
            v-model="assessment.point"
            :items="point_selection"
            label="ポイント数"
            class="ma-2"
          ></v-select>
        </v-col>

        <v-col cols="12" sm="4" md="4">
          <v-select
            v-model="assessment.num_files"
            :items="sample_selection"
            :label="`サンプル数`"
            class="ma-2"
          ></v-select>
        </v-col>
      </v-row>

      <v-row>
        <v-col 
          v-for="key in assessment.point" 
          :key="key"
        >
          <v-text-field
            :label="`評価値${key}のラベル`"
            v-model="criteria[key-1]"
            outlined
          ></v-text-field>
        </v-col>
      </v-row>

      <p>音声ファイルアップロード</p>
      <FileUploader :directory="'assessment/' + assessment.t_workflow_id + '/'" file_type="audio/*"></FileUploader>

      <p>PDFファイルアップロード</p>
      <FileUploader :directory="'assessment/' + assessment.t_workflow_id + '/'" file_type="application/pdf"></FileUploader>

    </v-card-text>
  </v-card>
</template>

<script>
import FileUploader from '@/components/FileUploader'
import PdfViewer from '@/components/PdfViewer'

export default {
  components: {
    FileUploader,
  },
  props: {
    assessment_prop: Object
  },
  data() {
    return {
      assessment: {
        is_practice: false,
        point: 0,
        pdf_url: "",
        num_files: 0,
        criteria: ""
      },
      point_selection: [...Array(10).keys()],
      sample_selection: [...Array(101).keys()],
      criteria: null
    }
  },
  watch: {
    criteria: function(newCriteria) {
      this.assessment.criteria = newCriteria.join(',')
    }
  },
  mounted() {
    if (this.assessment_prop!==undefined) {
      this.assessment = this.assessment_prop
      this.criteria = this.assessment.criteria.split(',')
    }
  }
}
</script>