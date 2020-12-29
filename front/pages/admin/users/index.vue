<template>
  <section>
    <div>
      <h1>New user</h1>
      <form @submit.prevent="post">

        <label for="email">Email: </label>
        <input id="email" v-model="email" type="text" name="email" />

        <label for="password">Password: </label>
        <input id="password" v-model="password" type="password" name="password" />

        <label for="password_confirmation">Password Confirmation: </label>
        <input id="password_confirmation" v-model="password_confirmation" type="password" name="password_confirmation" />

        <button type="submit">submit</button>
      </form>
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
      email: '',
      password: '',
      password_confirmation: ''
    }
  },
  methods: {
    post() {
      UserApi.createUser(this.email, this.password, this.password_confirmation).then((res) => {
        this.$router.push(`users/${res.id}`)
      })
    }
  }
}
</script>