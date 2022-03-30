<template>
  <v-container>
    <v-col offset-md="1" md="10" class="mt-3">
      <h3 class = "form-title text-center">ユーザー情報変更</h3>
      <Notification v-if="error" :message="error" class="mb-4 pb-3" />

      <v-form @submit.prevent="update">
        <v-card-text label="名前:">
          <v-text-field v-model="name" placeholder="Enter your nickname" required type="text" />
        </v-card-text>
        <v-card-text label="メールアドレス:">
          <v-text-field v-model="email" placeholder="Enter email" required type="email" />
        </v-card-text>
        <v-card-text label="パスワード:">
          <v-text-field v-model="password" placeholder="Enter password" required type="password" />
        </v-card-text>
        <v-card-text label="パスワード確認用:">
          <v-text-field v-model="password_confirmation" placeholder="password confirmation" required type="password" />
        </v-card-text>
        <v-btn block type="submit" variant="primary">Submit</v-btn>
      </v-form>
    </v-col>
  </v-container>
</template>

<script>

export default {
  middleware: 'auth',
  data: () => {
    return {
      name: '',
      email: '',
      password: '',
      password_confirmation: '',
      error: null
    }
  },
  methods: {
    async update () {
      try {
        await this.$axios.$put('/api/auth', {
          name: this.name,
          email: this.email,
          password: this.password,
          password_confirmation: this.password_confirmation
        })
        this.$router.push('/')
      } catch (e) {
        this.error = e.response.data.errors.full_messages
      }
    }
  }
}
</script>

<style></style>
