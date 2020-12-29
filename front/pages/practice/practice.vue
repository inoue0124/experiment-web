<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      <h1 align="center">実験方法</h1>

      <pdf
        class="pdf"
        :src="require('@/assets/example.pdf')"
        :page="1"
      ></pdf>

      <v-btn color="primary" @click="next">次へ進む</v-btn>

    </v-col>
  </v-row>
</template>

<script>
export default {
  data() {
    return {
    }
  },
  methods: {
    next() {
      this.$router.push(`assessment`)
    }
  }
}
</script>