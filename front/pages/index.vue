<template>
  <v-row>
    <v-col v-if="!$auth.loggedIn" cols="12" md="6">
      <SignUp />
    </v-col>
    <v-col cols="12" md="6">
      <Infomations />
    </v-col>
  </v-row>
</template>

<script>
export default {
  name: 'Index'
}
</script>
