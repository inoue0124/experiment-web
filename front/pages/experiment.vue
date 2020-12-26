<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">


      <v-btn color="primary" @click="next">次へ進む</v-btn>
    </v-col>
  </v-row>
</template>

<script>
export default {
  data() {
    return {}
  },
  methods: {
    next() {
      this.$router.push(`questionnaire`)
    }
  }
}
</script>