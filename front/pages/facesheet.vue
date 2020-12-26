<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      <h1 align="center">フェイスシート</h1>

        <v-form @submit.prevent="submit">

          <v-text-field
            v-model="name"
            label="氏名"
            required
          ></v-text-field>

          <v-text-field
            v-model="phone_number"
            label="電話番号"
            required
          ></v-text-field>

          <v-btn color="primary" type="submit">次へ進む</v-btn>

        </v-form>

    </v-col>
  </v-row>
</template>

<script>
export default {
  data() {
    return {
      name: '',
      phone_number: ''
    }
  },
  methods: {
    submit() {
      this.$router.push(`practice`)
    }
  }
}
</script>