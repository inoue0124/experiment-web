<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="12" lg="10" sm="10" md="10">
      <h1 align="center" class="mb-16">評価実験</h1>

      <PdfViewer class="mb-16"></PdfViewer>

      <v-simple-table>
        <template v-slot:default>
          <tbody>
            <tr
              v-for="item in samples"
              :key="item.file_number"
            >
              <td>
                <audio controls>
                  <source :src="item.url" type="audio/mpeg">
                </audio>
              </td>

              <td>
                <v-radio-group v-model="item.score" row>
                  <div v-for="val in 7" :key="val">
                    <v-radio :value=val></v-radio>
                  </div>
                </v-radio-group>
              </td>

              <td>
                <v-text-field
                  v-model="item.comment"
                  label="コメント"
                ></v-text-field>
              </td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>

      <div align="center" class="mt-10">
        <v-btn color="primary" @click="prev">前へ戻る</v-btn>
        <v-btn color="primary" @click="next">次へ進む</v-btn>
      </div>

    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import AssessmentApi from '@/plugins/axios/modules/assessment'
import PdfViewer from "@/components/PdfViewer"

export default {
  middleware: 'redirector',

  components: {
    PdfViewer
  },
  
  data() {
    return {
      samples: null,
      autoSaveTimer: null
    }
  },

  mounted() {
    this.getAssessmentWork()
    this.autoSaveTimer = setInterval(() => {
      AssessmentApi.update(this.$route.params.id, this.samples)
    }, 10000)
  },

  destroyed() {
    clearInterval(this.autoSaveTimer)
  },

  methods: {
    next() {
      AssessmentApi.update(this.$route.params.id, this.samples).then(() => {
        WorkflowApi.complete(this.$route.params.id).then((res) => {
          this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
        })
      })  
    },
    prev() {
      WorkflowApi.undo().then((res) => {
        this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
      })
    },
    getAssessmentWork() {
      AssessmentApi.getAssessmentWork(this.$route.params.id).then((res) => {
        this.samples = res
        console.log(res)
      })
    }
  }
}
</script>

<style lang="scss">
  td {
    background: #f0f8ff;
    border-bottom: none !important;
  }
  tr:nth-child(odd) td {
      background: #fff;
  }
</style>