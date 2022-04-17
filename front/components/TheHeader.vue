<template>
  <v-app-bar app clipped-left color="amber lighten-2" dense fixed>
    <v-app-bar-nav-icon @click="onClick()" />

    <v-toolbar-title>
      <NuxtLink to="/" class="text--secondary text-decoration-none">
        <h2>App</h2>
      </NuxtLink>
    </v-toolbar-title>
    <v-spacer />

    <keep-alive>
      <div v-if="$auth.loggedIn">
        <client-only>
          <v-btn large nuxt color="primary">ログアウト</v-btn>
        </client-only>
      </div>

      <div v-else>
        <client-only>
          <v-btn large nuxt to="/users/sign_in" color="primary">ログイン</v-btn>
        </client-only>
      </div>
    </keep-alive>
  </v-app-bar>
</template>

<script>
export default {
  methods: {
    onClick () {
      this.$store.commit('sidebar/onDrawer')
    }
  }
}
</script>
