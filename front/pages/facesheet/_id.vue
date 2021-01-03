<template>
  <v-row justify="center" align="center" class="my-5">
    <v-col cols="12" sm="8" md="6">
      <h1 align="center" class="mb-16">フェイスシート</h1>

        <v-form @submit.prevent="submit">

          <v-text-field
            v-if="t_facesheet.name"
            v-model="d_facesheet.name"
            label="氏名"
            required
          ></v-text-field>

          <v-text-field
            v-if="t_facesheet.phone"
            v-model="d_facesheet.phone"
            label="電話番号"
            required
          ></v-text-field>

          <div align="center">
            <v-btn color="primary" @click="next">次へ進む</v-btn>
          </div>

        </v-form>

    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'
import FacesheetApi from '@/plugins/axios/modules/facesheet'

export default {
  middleware: 'redirector',

  data() {
    return {
      t_facesheet: {},
      d_facesheet: {}
    }
  },

  mounted() {
    FacesheetApi.getTFacesheet(this.$route.params.id).then((res) => {
      this.t_facesheet = res
    })
  },

  methods: {
    next() {
      FacesheetApi.createDFacesheet(this.$route.params.id, this.d_facesheet).then((res)=>{
        WorkflowApi.complete(this.$route.params.id).then((res) => {
          this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
        })
      })
    }
  }
}
</script>