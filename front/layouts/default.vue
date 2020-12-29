<template>
  <v-app dark>
    <v-main>
      <v-container>
        <nuxt />
      </v-container>
    </v-main>
    <v-footer :absolute="true" app>
      <span>&copy; {{ new Date().getFullYear() }}
        東京大学 大学院総合文化研究科
        グローバルコミュニケーション研究センター
      </span>
    </v-footer>
  </v-app>
</template>

<script>
export default {
  data() {
    return {
    }
  },
}
</script>
