<template> 
    <v-container> 
      <v-col offset-md="1" md="10" class="mt-3">
        <h3 class = "text-center">ログイン</h3>

          <Notification :message="error" v-if="error" class="mb-4 pb-3" />

          <v-form @submit.prevent="login">
            <v-card-text label="メールアドレス:">
              <v-text-field placeholder="Enter email" required v-model="email" type="email"></v-text-field>
            </v-card-text>
            <v-card-text label="パスワード:">
              <v-text-field placeholder="Enter password" required v-model="password" type="password"></v-text-field>
            </v-card-text>
            <v-btn block type="submit" variant="primary">送信</v-btn>
          </v-form>
      </v-col>
    </v-container>
</template>

<script>
  export default {
    data: function () {
      return {
        email: '',
        password: '',
        error: null,
      }
    },
    methods: {
      async login() {
          await this.$auth.loginWith('local', {
            data: {
              password: this.password,
              email: this.email
            }
          })
          .then(
            (response) => {
            },
            (error) => {
              this.error = error.response.data.errors
            }
          )
      }
    }
  }
</script>

<style></style>
