<template>
  <h1>Hello, {{ name }}</h1>
</template>

<script>
import UserApi from '@/plugins/axios/modules/user'

export default {
  data() {
    return {
      email: ''
    }
  },
  asyncData({ $axios, params }) {
    return $axios.$get(`http://localhost:3000/users/${params.id}`)
      .then((res) => {
        return { name: res.name }
      })
  }
}
</script>