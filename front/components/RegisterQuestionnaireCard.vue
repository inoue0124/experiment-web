<template>
  <v-card>
    <v-card-text>
      <v-text-field
        label="GoogleフォームのURL"
        v-model="form_url"
        required
      ></v-text-field>
      <v-img
      :src="require('@/assets/google_form.png')"
      ></v-img>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  props: {
    form_url_prop: String
  },
  data() {
    return {
      form_url: ""
    }
  },
  mounted() {
    if (this.form_url_prop!==undefined) {
      this.form_url = this.form_url_prop
    }
  }
}
</script>