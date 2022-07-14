<template>
  <p>admin only</p>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  mixins: [Application],

  created () {
    if (!this.$auth.user.admin) {
      return this.redirectNotAdmin()
    }
    this.loading = false
  }
}
</script>
