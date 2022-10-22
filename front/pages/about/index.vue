<template>
  <div>
    <TheProcessing v-if="processing" />
    <v-img :src="image.FLOOD_IMAGE" max-height="450" gradient="to top right, rgba(100,115,201,.33), rgba(25,32,72,.5)" class="background-repeat: no-repeat; background-size: cover; background-position: center center;">
      <div class="mask rgba-gradient align-center">
        <v-container style="height: 100%!important">
          <v-row align="center" class="h-100">
            <v-col sm="11" md="8" lg="7" class="white--text text-center text-md-left mb-5 align-center" style="margin-top: 57px">
              <h1 class="mt-4 mt-sm-5 text-left">
                <p class="mb-1">防災タスクを達成してあなたの防災レベルをあげませんか？</p>
              </h1>

              <v-divider class="my-4" color="white" />

              <h5 class="mb-4 text-left">
                最近は災害が増えているため、みなさんの防災意識は高まっているのではないでしょうか。
                <br>
                しかし、「何から取り組めばいいんだろう」と悩んでいる人も多いはずです。
                <br>
                Bosai Lv (防災レベル) ではそんな方向けにやるべきことを「防災タスク」として設定しています。
                <br>
                しかも、「防災タスク」を達成するごとにポイントを獲得・あなたの防災レベルがあがります！
              </h5>

              <div class="text-center">
                <OrangeBtn to="/signup" class="h5 font-weight-bold" style="padding: 15px 40px">無料で登録</OrangeBtn>
                <GreenBtn class="h5 font-weight-bold ml-3" style="padding: 15px 40px" @click="onGuestSignIn">機能を試す</GreenBtn>
                <h5 class="mt-3">
                  <NuxtLink to="/signin" class="font-weight-bold" style="color: #00E676;">すでにアカウトをお持ちですか？ログイン</NuxtLink>
                </h5>
              </div>
            </v-col>

            <div class="d-none d-md-block col-md-4 col-lg-5 wow fadeInRight align-self-center" data-wow-delay="0.3s" style="margin-top: 80px">
              <v-img :src="image.FAMILY_IMAGE" class="float-right mt-5" style="max-width: 90%; height: auto; filter: drop-shadow(30px 25px 3px rgba(0, 0, 0, 0.514));" />
            </div>
          </v-row>
        </v-container>
      </div>
    </v-img>

    <v-container class="mt-3">
      <v-row class="my-1 my-sm-4" justify="center" no-gutters>
        <v-col cols="8" class="text-center">
          <v-img :src="image.LOGO_AND_CANDO_IMAGE" class="pb-1 pb-lg-2" max-height="65" />
        </v-col>
        <v-col cols="12">
          <v-divider class="my-1 mb-5" />
        </v-col>
      </v-row>

      <v-row justify="center" class="py-1 mb-3">
        <v-col cols="11" lg="7" xl="6" md="6" class="pl-lg-3 pl-xl-5 align-self-center">
          <h2 class="mb-4" style="color: #117768;">
            ハザードマップ・避難所などを検索できる
            <v-icon class="ml-1 ml-md-2 pb-1" color="#117768">mdi-magnify</v-icon>
          </h2>
          <h4 class="font-weight-light">
            市区町村のハザードマップや避難所を検索できます。災害は突然やってきます。自分の住むところは危険なのか、いざという時どこに避難すればいいのか、などを確認しておきましょう。
          </h4>
        </v-col>
        <v-col cols="11" lg="5" xl="6" md="6" class="text-center align-self-center">
          <v-img :src="image.SEARCH_DESKTOP_IMAGE" style="max-width: 100%; height: auto" />
        </v-col>
      </v-row>

      <v-row justify="center" class="py-1 mb-3">
        <v-col cols="11" lg="7" xl="6" md="6" class="pl-lg-3 pl-xl-5 align-self-center" order="1" order-sm="1" order-md="2" order-lg="2">
          <h2 class="mb-4" style="color: #117768;">
            防災タスクを達成して災害に備えましょう
            <v-icon class="ml-1 ml-md-2 pb-1" color="#117768">mdi-book-multiple</v-icon>
          </h2>
          <h4 class="font-weight-light">
            設定された防災タスクを1つずつ達成していくことで、災害に備えることができます。備えあれば憂いなしです。
          </h4>
        </v-col>
        <v-col cols="11" lg="5" xl="6" md="6" class="text-center align-self-center" order="2" order-sm="2" order-md="1" order-lg="1">
          <v-img :src="image.TASK_DESKTOP_IMAGE" style="max-width: 100%; height: auto" />
        </v-col>
      </v-row>

      <v-row justify="center" class="py-1 mb-3">
        <v-col cols="11" lg="7" xl="6" md="6" class="pl-lg-3 pl-xl-5 align-self-center">
          <h2 class="mb-4" style="color: #117768;">
            防災タスクを達成して獲得したポイントに応じて防災レベルが上がる
            <v-icon class="ml-1 ml-md-2 pb-1" color="#117768">mdi-transfer-up</v-icon>
          </h2>
          <h4 class="font-weight-light">
            防災タスクに達成するたびにポイントを獲得・防災レベルが上がります。あなたの防災レベルを上げて「楽しく」災害に備えていきましょう。
            詳細は、右上の<v-icon color="amber" class="pb-1">mdi-file-powerpoint-box</v-icon>をチェックしましょう。
          </h4>
        </v-col>
        <v-col cols="11" lg="5" xl="6" md="6" class="text-center align-self-center">
          <v-img :src="image.LEVELUP_DESKTOP_IMAGE" style="max-width: 100%; height: auto" />
        </v-col>
      </v-row>
    </v-container>

    <v-container style="margin-top: 120px">
      <v-row justify="center" no-gutters>
        <v-col cols="8" class="text-center">
          <v-img :src="image.LOGO_AND_WORRY_SOLUTION" class="pb-1 pb-lg-2" max-height="65" />
        </v-col>
        <v-col cols="12">
          <v-divider class="my-1 mb-5" />
        </v-col>

        <v-col cols="12">
          <v-row justify="space-around" align="center">
            <v-col xs="6" sm="5" md="4" lg="4" xl="4">
              <v-card class="pa-2 rounded-lg" elevation="0">
                <v-row>
                  <v-col cols="2" class="text-center align-self-center">
                    <v-icon color="#117768">mdi-checkbox-marked-circle</v-icon>
                  </v-col>
                  <v-col cols="10">
                    防災って何から始めればいいんだろう
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
            <v-col xs="6" sm="5" md="4" lg="4" xl="4">
              <v-card class="pa-2 rounded-lg" elevation="0">
                <v-row>
                  <v-col cols="2" class="text-center align-self-center">
                    <v-icon color="#117768">mdi-checkbox-marked-circle</v-icon>
                  </v-col>
                  <v-col cols="10">
                    防災ってむずかしそう
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
          </v-row>
          <v-row justify="space-between" align="center">
            <v-col xs="6" sm="5" md="4" lg="4" xl="4">
              <v-card class="pa-2 rounded-lg" elevation="0">
                <v-row>
                  <v-col cols="2" class="text-center align-self-center">
                    <v-icon color="#117768">mdi-checkbox-marked-circle</v-icon>
                  </v-col>
                  <v-col cols="10">
                    防災ってめんどくさそう
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
            <v-col xs="6" sm="5" md="4" lg="4" xl="4">
              <v-card class="pa-2 rounded-lg" elevation="0">
                <v-row>
                  <v-col cols="2" class="text-center align-self-center">
                    <v-icon color="#117768">mdi-checkbox-marked-circle</v-icon>
                  </v-col>
                  <v-col cols="10">
                    みんなの防災知識を参考にしたい
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
          </v-row>
        </v-col>

        <v-col cols="6" class="text-center align-self-center mt-3">
          <v-img :src="image.WORRIED_FAMILY_IMAGE" style="height: 100%;" />
        </v-col>
      </v-row>
    </v-container>

    <v-container style="margin-top: 120px">
      <v-row justify="center" align="center" no-gutters>
        <v-col cols="8" class="text-center">
          <h3>\  <span style="color: #117768;">簡単3ステップ♪</span>  /</h3>
        </v-col>
        <v-col cols="8" class="text-center">
          <v-img :src="image.LOGO_AND_USAGE_IMAGE" class="pb-1 pb-lg-2" max-height="65" />
          <v-divider class="my-1 mb-5" />
        </v-col>
        <v-row justify="center" align="center">
          <v-col cols="3" class="text-center align-self-center pa-3">
            <v-card class="pa-2 rounded-lg mb-3" elevation="0">
              <v-row>
                <v-icon style="position: absolute; z-index: 1;" color="#117768">
                  mdi-numeric-1-circle
                </v-icon>
                <v-col cols="12">
                  まずは新規登録！
                </v-col>
              </v-row>
            </v-card>
            <v-img :src="image.SIGNUP_MOBILE_IMAGE" />
          </v-col>
          <v-col cols="1" class="text-center align-self-center">
            <v-icon color="#117768" large>mdi-chevron-right</v-icon>
          </v-col>
          <v-col cols="3" class="text-center align-self-center pa-3">
            <v-card class="pa-2 rounded-lg mb-3" elevation="0">
              <v-row>
                <v-icon style="position: absolute; z-index: 1;" color="#117768">
                  mdi-numeric-2-circle
                </v-icon>
                <v-col cols="12">
                  プロフィールを設定
                </v-col>
              </v-row>
            </v-card>
            <v-img :src="image.SETTING_MOBILE_IMAGE" />
          </v-col>
          <v-col cols="1" class="text-center align-self-center">
            <v-icon color="#117768" large>mdi-chevron-right</v-icon>
          </v-col>
          <v-col cols="3" class="text-center align-self-center pa-3">
            <v-card class="pa-2 rounded-lg mb-3" elevation="0">
              <v-row>
                <v-icon style="position: absolute; z-index: 1;" color="#117768">
                  mdi-numeric-3-circle
                </v-icon>
                <v-col cols="12">
                  防災タスク達成！
                </v-col>
              </v-row>
            </v-card>
            <v-img :src="image.TASK_MOBILE_IMAGE" />
          </v-col>
        </v-row>
      </v-row>
    </v-container>

    <v-container style="margin-top: 120px">
      <v-row justify="center" no-gutters>
        <v-col md="12" class="text-center">
          <h1>ー さぁ、今すぐ無料で始めましょう ー</h1>
          <v-divider />
        </v-col>
        <v-col cols="12" class="text-center my-4">
          <h4 class="mb-3">全ての機能が無料で使えます。</h4>

          <div class="text-center">
            <OrangeBtn to="/signup" class="h5 font-weight-bold" style="padding: 20px 50px">無料で登録</OrangeBtn>
            <GreenBtn class="h5 font-weight-bold ml-3" style="padding: 20px 50px" @click="onGuestSignIn">機能を試す</GreenBtn>
            <h5 class="mt-3">
              <NuxtLink to="/signin" class="font-weight-bold" style="color: #00E676;">すでにアカウトをお持ちですか？ログイン</NuxtLink>
            </h5>
          </div>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import Application from '~/plugins/application.js'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'
import FLOOD_IMAGE from '~/assets/images/flood.jpeg'
import FAMILY_IMAGE from '~/assets/images/family.png'
import LOGO_AND_CANDO_IMAGE from '~/assets/images/logo_and_cando.png'
import LOGO_AND_WORRY_SOLUTION from '~/assets/images/logo_and_worry_solution.png'
import LOGO_AND_USAGE_IMAGE from '~/assets/images/loga_and_usage.png'
import SEARCH_DESKTOP_IMAGE from '~/assets/images/search_desktop.png'
import TASK_DESKTOP_IMAGE from '~/assets/images/task_desktop.png'
import LEVELUP_DESKTOP_IMAGE from '~/assets/images/levelup_desktop.png'
import WORRIED_FAMILY_IMAGE from '~/assets/images/worried_family.png'
import WORRIED_BOY_IMAGE from '~/assets/images/worried_boy.png'
import WORRIED_GIRL_IMAGE from '~/assets/images/worried_girl.png'
import DISCOVER_BOY_IMAGE from '~/assets/images/discover_boy.png'
import SIGNUP_MOBILE_IMAGE from '~/assets/images/signup_mobile.png'
import SETTING_MOBILE_IMAGE from '~/assets/images/setting_mobile.png'
import TASK_MOBILE_IMAGE from '~/assets/images/task_mobile.png'

export default {
  name: 'AboutIndexCard',

  components: {
    OrangeBtn,
    GreenBtn
  },

  mixins: [Application],

  computed: {
    image () {
      return {
        FLOOD_IMAGE,
        FAMILY_IMAGE,
        LOGO_AND_CANDO_IMAGE,
        LOGO_AND_WORRY_SOLUTION,
        LOGO_AND_USAGE_IMAGE,
        SEARCH_DESKTOP_IMAGE,
        TASK_DESKTOP_IMAGE,
        LEVELUP_DESKTOP_IMAGE,
        WORRIED_FAMILY_IMAGE,
        WORRIED_BOY_IMAGE,
        WORRIED_GIRL_IMAGE,
        DISCOVER_BOY_IMAGE,
        SIGNUP_MOBILE_IMAGE,
        SETTING_MOBILE_IMAGE,
        TASK_MOBILE_IMAGE
      }
    },

    authRedirectPath () {
      return (this.$auth.user.prefecture == null && this.$auth.user.city == null) ? { path: '/settings/profile' } : { path: '/home' }
    }
  },

  created () {
    this.processing = false
    this.loading = false
  },

  methods: {
    async onGuestSignIn () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.guestSignInUrl)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$auth.loginWith('local', {
              data: {
                email: response.data.email,
                password: response.data.password
              }
            })
              .then((response) => {
                if (response.data == null) {
                  this.$toasted.error(this.$t('system.error'))
                } else {
                  this.$toasted.error(response.data.alert)
                  this.$toasted.success(response.data.notice)
                  this.$router.push(this.authRedirectPath)
                }
              },
              (error) => {
                if (error.response == null) {
                  this.$toasted.error(this.$t('network.failure'))
                } else if (error.response.data == null) {
                  this.$toasted.error(this.$t('network.error'))
                } else {
                  this.$emit('alert', error.response.data.alert)
                  this.$emit('notice', error.response.data.notice)
                }
              })
            this.$toasted.error(response.data.alert)
            this.$toasted.success(response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$emit('alert', error.response.data.alert)
            this.$emit('notice', error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>

<style lang="scss" scoped>
.wrap-text {
  word-break: break-all;
  white-space: normal;
}
</style>
