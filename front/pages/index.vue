<template>
  <v-container>
    <v-col offset-md="1" md="10" class="mt-3">
        <v-card class="pb-5">
          <template #header>Hello World!</template>
          <div v-if="this.$auth.loggedIn">
            <h2>ログイン済み</h2>
          </div>
          <div v-if="!this.$auth.loggedIn">
            <h2>未ログイン</h2>
          </div>
          <hr class="my-4">
          <v-btn v-if="!this.$auth.loggedIn" variant="primary" to="/signup">サインアップ</v-btn>
          <v-btn v-if="!this.$auth.loggedIn" variant="info" to="/login">ログイン</v-btn>
          <v-btn v-if="this.$auth.loggedIn" variant="success" to="/update">アカウント情報変更</v-btn>
          <v-btn v-if="this.$auth.loggedIn" variant="danger" @click="logout">ログアウト</v-btn>
        </v-card>
    </v-col>
  </v-container>
</template>

<script>
  export default({
    data: function () {
      return {
      }
    },
    methods: {
      async logout() {
        await this.$auth.logout()
        .then( 
          ()=>{
            localStorage.removeItem("access-token")
            localStorage.removeItem("client")
            localStorage.removeItem("uid")
            localStorage.removeItem("token-type")
          }
        )
      }
    }
  })
</script>

<style></style>
