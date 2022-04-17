<template>
  <v-card max-width="480px">
    <div v-if="$auth.loggedIn">
      <h2>ログイン済み</h2>
    </div>
    <div v-if="!$auth.loggedIn">
      <h2>未ログイン</h2>
    </div>
    <hr class="my-4">
    <v-btn v-if="!$auth.loggedIn" variant="primary" to="users/sign_up">サインアップ</v-btn>
    <v-btn v-if="!$auth.loggedIn" variant="info" to="users/sign_in">ログイン</v-btn>
    <v-btn v-if="$auth.loggedIn" variant="danger" to="/users/sign_out">ログアウト</v-btn>
  </v-card>
</template>

<script>
export default ({
  // methods: {
  //   async logout () {
  //     await $auth.logout()
  //       .then(
  //         () => {
  //           localStorage.removeItem('access-token')
  //           localStorage.removeItem('client')
  //           localStorage.removeItem('uid')
  //           localStorage.removeItem('token-type')
  //         }
  //       )
  //   }
  // }
})
</script>

<style></style>
