<template>
  <v-card>
    <v-card-text>
      <v-text-field
        label="GoogleフォームのURL"
        v-model="form_url"
        required
      ></v-text-field>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  data() {
    return {
      form_url: ""
    }
  }
}
</script>