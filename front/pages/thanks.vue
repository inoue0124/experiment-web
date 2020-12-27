<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      <v-card class="pa-md-10 mx-lg-auto">
        <v-card-title class="headline">
          実験にご参加いただき誠にありがとうございました。
        </v-card-title>

        <v-cart-text>
          お問い合わせは
          <a href="mailto:example@mail.com" target="_blank">example@mail.com</a>
          までお願いします。
        </v-cart-text>

      </v-card>
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
  }
}
</script>