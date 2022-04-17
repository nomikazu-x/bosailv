<template>
  <ul class="my-2">
    <li v-if="action !== 'sign_in'"><NuxtLink to="/users/sign_in">ログイン</NuxtLink></li>
    <li v-if="action !== 'sign_up'"><NuxtLink to="/users/sign_up">アカウント登録</NuxtLink></li>
  </ul>
</template>

<script>
export default {
  name: 'UsersActionLink',

  props: {
    action: {
      type: String,
      default: null
    }
  }
}
</script>
