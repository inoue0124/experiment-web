<template>
  <div style="position:relative;">
    <pdf
      :src="require('@/assets/example.pdf')"
      :page="page"
      :key="page"
      @num-pages="pageCount = $event"
			@page-loaded="currentPage = $event"
    >
    </pdf>

    <v-btn
      icon
      tile
      @click="prev"
      :disabled="currentPage===1"
      class="py-16 px-10 control-btn"
    >
      <v-icon dark>mdi-less-than</v-icon>
    </v-btn>

    <p style="position:absolute;top:0;right:0;">{{currentPage}} / {{pageCount}}</p>

    <v-btn
      icon
      tile
      @click="next"
      :disabled="currentPage===pageCount"
      style="right:0;"
      class="py-16 px-10 control-btn"
    >
      <v-icon dark>mdi-greater-than</v-icon>
    </v-btn>
  </div>
</template>

<script>
export default {
  props: {
    url: String
  },
  data() {
    return {
      page: 1,
      currentPage: 0,
      pageCount: 0
    }
  },
  methods: {
    next() {
      this.page+=1
    },
    prev() {
      this.page-=1
    }
  }
}
</script>
<style scoped>
.control-btn {
  position: absolute;
  top: 40%;
}
</style>