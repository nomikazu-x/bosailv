<template>
  <v-alert v-if="$auth.loggedIn && $auth.user != null && $auth.user.destroy_schedule_at != null" type="warning">
    このゲストアカウントは{{ $dateFormat($auth.user.destroy_schedule_at, 'ja') || 'N/A' }}以降に削除されます。
  </v-alert>
</template>

<script>
export default {
  name: 'DestroyInfo'
}
</script>
