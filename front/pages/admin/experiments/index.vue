<template>
  <section>
    <div>
      <h1>実験管理</h1>
    </div>
  </section>
</template>

<script>
import UserApi from '@/plugins/axios/modules/user'

export default {
  layout: 'admin',
  middleware: 'admin-redirector',

  data() {
    return {
    }
  },
  methods: {
  }
}
</script>