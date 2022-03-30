<template>
  <v-card max-width="480px">
    <div v-if="this.$auth.loggedIn">
      <h2>ログイン済み</h2>
    </div>
    <div v-if="!this.$auth.loggedIn">
      <h2>未ログイン</h2>
    </div>
    <hr class="my-4">
    <v-btn v-if="!this.$auth.loggedIn" variant="primary" to="/signup">サインアップ</v-btn>
    <v-btn v-if="!this.$auth.loggedIn" variant="info" to="/login">ログイン</v-btn>
    <v-btn v-if="this.$auth.loggedIn" variant="danger" @click="logout">ログアウト</v-btn>
  </v-card>
</template>

<script>
export default ({
  methods: {
    async logout () {
      await this.$auth.logout()
        .then(
          () => {
            localStorage.removeItem('access-token')
            localStorage.removeItem('client')
            localStorage.removeItem('uid')
            localStorage.removeItem('token-type')
          }
        )
    }
  }
})
</script>

<style></style>
