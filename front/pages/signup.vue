<template> 
  <v-container> 
    <v-col offset-md="1" md="10" class="mt-3">
      <h3 class="text-center">登録ページ</h3>

      <Notification :message="error" v-if="error" class="mb-4 pb-3" />

      <v-form @submit.prevent="signup">
        <v-card-text label="名前:">
          <v-text-field placeholder="Enter your nickname" required v-model="name" type="text"></v-text-field>
        </v-card-text>
        <v-card-text label="メールアドレス:">
          <v-text-field placeholder="Enter email" required v-model="email" type="email"></v-text-field>
        </v-card-text>
        <v-card-text label="パスワード:">
          <v-text-field placeholder="Enter password" required v-model="password" type="password"></v-text-field>
        </v-card-text>
        <v-card-text label="パスワード確認用:">
          <v-text-field placeholder="password confirmation" required v-model="password_confirmation" type="password"></v-text-field>
        </v-card-text>
        <v-btn block type="submit" variant="primary">Submit</v-btn>
      </v-form>
    </v-col>
  </v-container>
</template>

<script>

export default{
  data: function () {
    return {
        name: '',
        email: '',
        password: '',
        password_confirmation: '',
        error: null
    }
  },
  methods: {
    async signup() {
      try{
        await this.$axios.post('/api/auth',{
            name: this.name,
            email: this.email,
            password: this.password,
            password_confirmation: this.password_confirmation
        })    
        await this.$auth.loginWith('local', {
          data: {
            password: this.password,
            email: this.email
          },
        })    
      }catch(e){
        this.error = e.response.data.errors.full_messages
      }
    }
  }
}
</script>

<style></style>
