<template>
  <v-container class='main-heading text-center'>
    <div class='mt-2 mt-sm-4'>
      <h1 class='error-code'>{{ error.statusCode }}</h1>

      <h2 class='mb-2'>{{ title }}</h2>

      <h3 class='mb-2'>{{ message }}</h3>

      <p class='mb-2'><nuxt-link to='/'>Home</nuxt-link></p>
    </div>
  </v-container>
</template>

<script>
const defaultErrorMessages = {
  401: {
    title: 'Unauthorized',
    message: '認証ができていません'
  },
  403: {
    title: 'Forbidden',
    message: 'ページを見る権限がありません'
  },
  404: {
    title: 'Page Not Found',
    message: 'ページが存在しません'
  },
  500: {
    title: 'Internal Server Error',
    message: 'エラーが発生しました'
  }
}

const getErrorMessage = (statusCode = null) => {
  statusCode = String(statusCode) || '500' // statusCodeがnullのとき、500にする。
  for (const v in defaultErrorMessages) {
    if (v === statusCode) {
      return defaultErrorMessages[v]
    }
  }
  return defaultErrorMessages['500']
}

export default {
  props: ['error'],

  computed: {
    title () {
      return this.errorMessageObj.title
    },

    message () {
      return this.errorMessageObj.message
    },

    errorMessageObj () {
      return getErrorMessage(this.error.statusCode)
    }
  }
}
</script>

<style scoped lang='scss'>
.error-code {
  font-size: 3rem;
}
</style>
