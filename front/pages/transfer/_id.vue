<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      振り込み情報

      <v-btn color="primary" @click="next">次へ進む</v-btn>
    </v-col>
  </v-row>
</template>

<script>
import WorkflowApi from '@/plugins/axios/modules/workflow'

export default {
  middleware: 'redirector',

  data() {
    return {}
  },

  methods: {
    next() {
      WorkflowApi.complete(this.$route.params.id).then((res) => {
        this.$router.push(`/${res.work.name.toLowerCase()}/${res.workflow.id}`)
      })
    }
  }
}
</script>