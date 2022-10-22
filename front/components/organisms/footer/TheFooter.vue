<template>
  <div :style="{ marginTop: `${height}px` }">
    <v-footer app absolute inset color="#FFFCFC" :height="height">
      <v-row justify="center" algin="center" class="mt-2">
        <v-col cols="4">
          <NuxtLink to="/home" class="toolbar-title d-flex text-decoration-none">
            <v-toolbar-title
              v-if="$vuetify.breakpoint.width > 226"
              :style="{ 'max-width': ($vuetify.breakpoint.width - 226) + 'px' }"
              class="ml-1 align-self-center d-inline-block text-truncate text--secondary"
            >
              <v-img :src="image.HEADER_LOGO" />
            </v-toolbar-title>
          </NuxtLink>
        </v-col>
        <v-col cols="4">
          <ul class="list-style-none pl-0">
            <li class="mb-1">
              <NuxtLink
                to="/about"
                style="color: inherit;"
                class="text-decoration-none text--secondary"
              >
                BosaiLvとは？
              </NuxtLink>
            </li>
            <li class="mb-1">
              <NuxtLink
                to="/signup"
                style="color: inherit;"
                class="text-decoration-none text--secondary"
              >
                新規登録/ログイン
              </NuxtLink>
            </li>
          </ul>
        </v-col>
        <v-col cols="4">
          <ul class="list-style-none pl-0">
            <li class="mb-1">
              <NuxtLink
                to="/rules"
                style="color: inherit;"
                class="text-decoration-none text--secondary"
              >
                利用規約
              </NuxtLink>
            </li>
            <li class="mb-1">
              <NuxtLink
                to="/privacy_policy"
                style="color: inherit;"
                class="text-decoration-none text--secondary"
              >
                プライバシーポリシー
              </NuxtLink>
            </li>
          </ul>
        </v-col>
        <v-col cols="12" class="p-0">
          <v-divider class="mb-2" />
          <div class="text-center text-decoration-none text--secondary">
            &copy;{{ copyRightYear }}
            <a :href="$t('my_url')" target="_blank" rel="noopener noreferrer">{{
              $t("my_name")
            }}</a>
          </div>
        </v-col>
      </v-row>
    </v-footer>
  </div>
</template>

<script>
import HEADER_LOGO from '~/assets/images/header_logo.jpg'

export default {
  data () {
    return {
      height: 100
    }
  },
  computed: {
    image () {
      return {
        HEADER_LOGO
      }
    },
    copyRightYear () {
      const beginningYear = 2021
      const thisYear = new Date().getFullYear()
      return beginningYear < thisYear
        ? `${beginningYear} - ${thisYear}`
        : beginningYear
    }
  }
}
</script>
