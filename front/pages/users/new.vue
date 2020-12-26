<template>
  <section>
    <div>
      <h1>New user</h1>
      <form @submit.prevent="post">

        <label for="name">Name: </label>
        <input id="name" v-model="name" type="text" name="name" />

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
export default {
  data() {
    return {
      name: '',
      email: '',
      password: '',
      password_confirmation: ''
    }
  },
  methods: {
    post() {
      this.$axios.post(
        'http://localhost:3000/users',
        {
          name: this.name,
          email: this.email,
          password: this.password,
          password_confirmation: this.password_confirmation
        }
      ).then((res) => {
        this.$router.push(`users/${res.data.id}`)
      })
    }
  }
}
</script>