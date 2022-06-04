<template>
  <div>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />
    <v-card v-if="!loading">
      <v-row>
        <v-col cols="auto">
          <UserImageFileInput :alert="alert" :notice="notice" />
        </v-col>
        <v-col cols="12">
          <UserProfileForm :user="user" :alert="alert" :notice="notice" />
        </v-col>
      </v-row>
    </v-card>
  </div>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      default: null
    },
    loading: {
      type: Boolean,
      default: false
    },
    alert: {
      type: String,
      default: null
    },
    notice: {
      type: String,
      default: null
    }
  }
}
</script>
