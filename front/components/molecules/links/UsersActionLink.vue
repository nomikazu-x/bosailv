<template>
  <ul class="mt-2 list-style-none">
    <li v-if="action !== 'sign_in'"><NuxtLink to="/signin">ログイン</NuxtLink></li>
    <li v-if="action !== 'sign_up'"><NuxtLink to="/signup">アカウント登録</NuxtLink></li>
    <li v-if="action !== 'password'"><NuxtLink to="/password/reset">パスワード再設定</NuxtLink></li>
    <li v-if="action !== 'confirmation'"><NuxtLink to="/users/confirmation/new">メールアドレス確認</NuxtLink></li>
    <li v-if="action !== 'unlock'"><NuxtLink to="/users/unlock/new">アカウントロック解除</NuxtLink></li>
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
