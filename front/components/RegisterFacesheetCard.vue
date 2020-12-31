<template>
  <v-card>
    <v-card-text>
      <v-checkbox
        v-for="(item, key) in facesheet"
        :key="key"
        v-model="facesheet[key]"
        :label="facesheet_ja[key]"
      ></v-checkbox>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  data() {
    return {
      facesheet: {
        name: true,
        phone: false
      },
      facesheet_ja: {
        name: "氏名",
        phone: "電話番号"
      }
    }
  }
}
</script>