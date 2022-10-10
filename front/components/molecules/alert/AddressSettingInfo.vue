<template>
  <v-alert v-if="$auth.loggedIn && $auth.user != null && ($auth.user.prefecture == null && $auth.user.city == null)" type="warning">
    あなたの住んている市町村・都道府県を登録しておきましょう。
    <br>避難所やハザードマップの検索が簡単にできるようになります。
  </v-alert>
</template>

<script>
export default {
  name: 'AddressSettingInfo'
}
</script>
