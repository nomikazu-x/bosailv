<template>
  <v-card>
    <v-card-title>新規登録はこちら</v-card-title>
    <v-card-text>
      <RedBtn to="/signup" nuxt>無料で始める</RedBtn>
    </v-card-text>
    <v-divider />
    <v-card-actions class="ml-3">
      <NuxtLink to="/signin" class="text-decoration-none">ログイン</NuxtLink>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  name: 'IndexSignUp'
}
</script>
