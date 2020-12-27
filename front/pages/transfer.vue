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
  data() {
    return {}
  },
  mounted () {
    WorkflowApi.getNextWork().then((res) => {
      this.$router.push(res.name.toLowerCase())
    })
  },
  methods: {
    next() {
      WorkflowApi.completeWork().then((res) => {
        this.$router.push(res.name.toLowerCase())
      })
    }
  }
}
</script>