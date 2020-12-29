<template>
</template>

<script>
import SessionApi from '@/plugins/axios/modules/session'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',

  created() {
    SessionApi.logout().then(()=>{
      this.$router.push('/')
    })
  }
}
</script>